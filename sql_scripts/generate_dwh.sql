CREATE DATABASE CityBikesDWH
GO
USE CityBikesDWH
GO
-- ************************************** [Bike_Dim]
CREATE TABLE [Bike_Dim]
(
 [BikeID]          int NOT NULL ,
 [BikeType]        varchar(50) NOT NULL ,
 [LastServiceDate] date NOT NULL ,


 CONSTRAINT [PK_39] PRIMARY KEY CLUSTERED ([BikeID] ASC)
);
GO
-- ************************************** [Date_Dim]
--cast(convert(char(8), @Date, 112) as int)       AS DateID,
DECLARE @StartDate DATE = '19000101', @NumberOfYears INT = 200;



-- prevent set or regional settings from interfering with
-- interpretation of dates / literals



SET DATEFIRST 7;
SET DATEFORMAT mdy;
SET LANGUAGE US_ENGLISH;



DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate);



-- this is just a holding table for intermediate calculations:



CREATE TABLE #dim
(
[date] DATE PRIMARY KEY,
[day] AS DATEPART(DAY, [date]),
[month] AS DATEPART(MONTH, [date]),
FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0)),
[MonthName] AS DATENAME(MONTH, [date]),
[week] AS DATEPART(WEEK, [date]),
[ISOweek] AS DATEPART(ISO_WEEK, [date]),
[DayOfWeek] AS DATEPART(WEEKDAY, [date]),
[quarter] AS DATEPART(QUARTER, [date]),
[year] AS DATEPART(YEAR, [date]),
FirstOfYear AS CONVERT(DATE, DATEADD(YEAR, DATEDIFF(YEAR, 0, [date]), 0)),
Style112 AS CONVERT(CHAR(8), [date], 112),
Style101 AS CONVERT(CHAR(10), [date], 101)
);



-- use the catalog views to generate as many rows as we need



--DECLARE @StartDate DATE = '19000101', @NumberOfYears INT = 200;
--DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate);



INSERT #dim([date])
SELECT d
FROM
(
SELECT d = DATEADD(DAY, rn - 1, @StartDate)
FROM
(
SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate))
rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
FROM sys.all_objects AS s1
CROSS JOIN sys.all_objects AS s2
-- on my system this would support > 5 million days
ORDER BY s1.[object_id]
) AS x
) AS y;



CREATE TABLE dbo.Date_Dim
(
DateID INT NOT NULL PRIMARY KEY,
[Date] DATE NOT NULL,
[Day] TINYINT NOT NULL,
DaySuffix CHAR(2) NOT NULL,
[Weekday] TINYINT NOT NULL,
WeekDayName VARCHAR(10) NOT NULL,
IsWeekend BIT NOT NULL,
IsHoliday BIT NOT NULL,
HolidayText VARCHAR(64) SPARSE,
DOWInMonth TINYINT NOT NULL,
[DayOfYear] SMALLINT NOT NULL,
WeekOfMonth TINYINT NOT NULL,
WeekOfYear TINYINT NOT NULL,
ISOWeekOfYear TINYINT NOT NULL,
[Month] TINYINT NOT NULL,
[MonthName] VARCHAR(10) NOT NULL,
[Quarter] TINYINT NOT NULL,
QuarterName VARCHAR(6) NOT NULL,
[Year] INT NOT NULL,
MMYYYY CHAR(6) NOT NULL,
MonthYear CHAR(7) NOT NULL,
FirstDayOfMonth DATE NOT NULL,
LastDayOfMonth DATE NOT NULL,
FirstDayOfQuarter DATE NOT NULL,
LastDayOfQuarter DATE NOT NULL,
FirstDayOfYear DATE NOT NULL,
LastDayOfYear DATE NOT NULL,
FirstDayOfNextMonth DATE NOT NULL,
FirstDayOfNextYear DATE NOT NULL
);
GO
GO



INSERT dbo.Date_Dim WITH (TABLOCKX)
SELECT
DateID = CONVERT(INT, Style112),
[Date] = [date],
[Day] = CONVERT(TINYINT, [day]),
DaySuffix = CONVERT(CHAR(2), CASE WHEN [day] / 10 = 1 THEN 'th' ELSE
CASE RIGHT([day], 1) WHEN '1' THEN 'st' WHEN '2' THEN 'nd'
WHEN '3' THEN 'rd' ELSE 'th' END END),
[Weekday] = CONVERT(TINYINT, [DayOfWeek]),
[WeekDayName] = CONVERT(VARCHAR(10), DATENAME(WEEKDAY, [date])),
[IsWeekend] = CONVERT(BIT, CASE WHEN [DayOfWeek] IN (1,7) THEN 1 ELSE 0 END),
[IsHoliday] = CONVERT(BIT, 0),
HolidayText = CONVERT(VARCHAR(64), NULL),
[DOWInMonth] = CONVERT(TINYINT, ROW_NUMBER() OVER
(PARTITION BY FirstOfMonth, [DayOfWeek] ORDER BY [date])),
[DayOfYear] = CONVERT(SMALLINT, DATEPART(DAYOFYEAR, [date])),
WeekOfMonth = CONVERT(TINYINT, DENSE_RANK() OVER
(PARTITION BY [year], [month] ORDER BY [week])),
WeekOfYear = CONVERT(TINYINT, [week]),
ISOWeekOfYear = CONVERT(TINYINT, ISOWeek),
[Month] = CONVERT(TINYINT, [month]),
[MonthName] = CONVERT(VARCHAR(10), [MonthName]),
[Quarter] = CONVERT(TINYINT, [quarter]),
QuarterName = CONVERT(VARCHAR(6), CASE [quarter] WHEN 1 THEN 'First'
WHEN 2 THEN 'Second' WHEN 3 THEN 'Third' WHEN 4 THEN 'Fourth' END),
[Year] = [year],
MMYYYY = CONVERT(CHAR(6), LEFT(Style101, 2) + LEFT(Style112, 4)),
MonthYear = CONVERT(CHAR(7), LEFT([MonthName], 3) + LEFT(Style112, 4)),
FirstDayOfMonth = FirstOfMonth,
LastDayOfMonth = MAX([date]) OVER (PARTITION BY [year], [month]),
FirstDayOfQuarter = MIN([date]) OVER (PARTITION BY [year], [quarter]),
LastDayOfQuarter = MAX([date]) OVER (PARTITION BY [year], [quarter]),
FirstDayOfYear = FirstOfYear,
LastDayOfYear = MAX([date]) OVER (PARTITION BY [year]),
FirstDayOfNextMonth = DATEADD(MONTH, 1, FirstOfMonth),
FirstDayOfNextYear = DATEADD(YEAR, 1, FirstOfYear)
FROM #dim
OPTION (MAXDOP 1);



;WITH x AS
(
SELECT /* DateKey, */ [Date], IsHoliday, HolidayText, FirstDayOfYear,
DOWInMonth, [MonthName], [WeekDayName], [Day],
LastDOWInMonth = ROW_NUMBER() OVER
(
PARTITION BY FirstDayOfMonth, [Weekday]
ORDER BY [Date] DESC
)
FROM dbo.Date_Dim
)
UPDATE x SET IsHoliday = 1, HolidayText = CASE
WHEN ([Date] = FirstDayOfYear)
THEN 'New Year''s Day'
WHEN ([DOWInMonth] = 3 AND [MonthName] = 'January' AND [WeekDayName] = 'Monday')
THEN 'Martin Luther King Day' -- (3rd Monday in January)
WHEN ([DOWInMonth] = 3 AND [MonthName] = 'February' AND [WeekDayName] = 'Monday')
THEN 'President''s Day' -- (3rd Monday in February)
WHEN ([LastDOWInMonth] = 1 AND [MonthName] = 'May' AND [WeekDayName] = 'Monday')
THEN 'Memorial Day' -- (last Monday in May)
WHEN ([MonthName] = 'July' AND [Day] = 4)
THEN 'Independence Day' -- (July 4th)
WHEN ([DOWInMonth] = 1 AND [MonthName] = 'September' AND [WeekDayName] = 'Monday')
THEN 'Labour Day' -- (first Monday in September)
WHEN ([DOWInMonth] = 2 AND [MonthName] = 'October' AND [WeekDayName] = 'Monday')
THEN 'Columbus Day' -- Columbus Day (second Monday in October)
WHEN ([MonthName] = 'November' AND [Day] = 11)
THEN 'Veterans'' Day' -- Veterans' Day (November 11th)
WHEN ([DOWInMonth] = 4 AND [MonthName] = 'November' AND [WeekDayName] = 'Thursday')
THEN 'Thanksgiving Day' -- Thanksgiving Day (fourth Thursday in November)
WHEN ([MonthName] = 'December' AND [Day] = 25)
THEN 'Christmas Day'
END
WHERE
([Date] = FirstDayOfYear)
OR ([DOWInMonth] = 3 AND [MonthName] = 'January' AND [WeekDayName] = 'Monday')
OR ([DOWInMonth] = 3 AND [MonthName] = 'February' AND [WeekDayName] = 'Monday')
OR ([LastDOWInMonth] = 1 AND [MonthName] = 'May' AND [WeekDayName] = 'Monday')
OR ([MonthName] = 'July' AND [Day] = 4)
OR ([DOWInMonth] = 1 AND [MonthName] = 'September' AND [WeekDayName] = 'Monday')
OR ([DOWInMonth] = 2 AND [MonthName] = 'October' AND [WeekDayName] = 'Monday')
OR ([MonthName] = 'November' AND [Day] = 11)
OR ([DOWInMonth] = 4 AND [MonthName] = 'November' AND [WeekDayName] = 'Thursday')
OR ([MonthName] = 'December' AND [Day] = 25);



UPDATE d SET IsHoliday = 1, HolidayText = 'Black Friday'
FROM dbo.Date_Dim AS d
INNER JOIN
(
SELECT /* DateKey, */ [Date], [Year], [DayOfYear]
FROM dbo.Date_Dim
WHERE HolidayText = 'Thanksgiving Day'
) AS src
ON d.[Year] = src.[Year]
AND d.[DayOfYear] = src.[DayOfYear] + 1;
GO
CREATE FUNCTION dbo.GetEasterHolidays(@year INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
WITH x AS
(
SELECT [Date] = CONVERT(DATE, RTRIM(@year) + '0' + RTRIM([Month])
+ RIGHT('0' + RTRIM([Day]),2))
FROM (SELECT [Month], [Day] = DaysToSunday + 28 - (31 * ([Month] / 4))
FROM (SELECT [Month] = 3 + (DaysToSunday + 40) / 44, DaysToSunday
FROM (SELECT DaysToSunday = paschal - ((@year + @year / 4 + paschal - 13) % 7)
FROM (SELECT paschal = epact - (epact / 28)
FROM (SELECT epact = (24 + 19 * (@year % 19)) % 30)
AS epact) AS paschal) AS dts) AS m) AS d
)
SELECT [Date], HolidayName = 'Easter Sunday' FROM x
UNION ALL SELECT DATEADD(DAY,-2,[Date]), 'Good Friday' FROM x
UNION ALL SELECT DATEADD(DAY, 1,[Date]), 'Easter Monday' FROM x
);
GO
;WITH x AS
(
SELECT d.[Date], d.IsHoliday, d.HolidayText, h.HolidayName
FROM dbo.Date_Dim AS d
CROSS APPLY dbo.GetEasterHolidays(d.[Year]) AS h
WHERE d.[Date] = h.[Date]
)
UPDATE x SET IsHoliday = 1, HolidayText = HolidayName;


-- ************************************** [Station_Dim]
CREATE TABLE [Station_Dim]
(
 [StationID]    int NOT NULL ,
 [StationName]  varchar(100) NOT NULL ,
 [Latitude]     float NOT NULL ,
 [Longitude]    float NOT NULL ,
 [Neighborhood] varchar(50) NOT NULL ,
 [Road]         varchar(50) NOT NULL ,
 [Suburb]       varchar(50) NOT NULL ,


 CONSTRAINT [PK_18] PRIMARY KEY CLUSTERED ([StationID] ASC)
);
GO
-- ************************************** [Weather_Dim]
CREATE TABLE [Weather_Dim]
(
 [DateID]               int NOT NULL ,
 [LocalizationName]     varchar(100) NOT NULL ,
 [Date]                 date NOT NULL ,
 [Temperature]          float NOT NULL ,
 [FeelsLikeTemperature] float NOT NULL ,
 [Precipitation]        float NOT NULL ,
 [IsRain]               varchar(50) NOT NULL ,
 [Windspeed]            float NOT NULL ,
 [CloudCover]           float NOT NULL ,
 [Conditions]           varchar(100) NOT NULL ,
 [IsSnow]               varchar(50) NOT NULL ,
 [IsOtherPrecipitation] varchar(50) NOT NULL ,


 CONSTRAINT [PK_88] PRIMARY KEY CLUSTERED ([DateID] ASC)
);
GO
-- ************************************** [Hire_Fact]
CREATE TABLE [Hire_Fact]
(
 [HireID]         int identity(1,1),
 [StartTime]      datetime NOT NULL ,
 [EndTime]        datetime NOT NULL ,
 [StartStationID] int NOT NULL ,
 [EndStationID]   int NOT NULL ,
 [TripDuration]   int NOT NULL ,
 [TripDistance]   float NOT NULL ,
 [Gender]         varchar(50) NOT NULL ,
 [BirthYear]      int NOT NULL ,
 [Usertype]       varchar(50) NOT NULL ,
 [BikeID]         int NOT NULL ,
 [StartDateID]    int NOT NULL ,
 [EndDateID]      int NOT NULL ,


 CONSTRAINT [PK_5] PRIMARY KEY CLUSTERED ([HireID] ASC),
 CONSTRAINT [FK_Fact_Bike] FOREIGN KEY ([BikeID])  REFERENCES [Bike_Dim]([BikeID]),
 CONSTRAINT [FK_Fact_EndDate] FOREIGN KEY ([EndDateID])  REFERENCES [Date_Dim]([DateID]),
 CONSTRAINT [FK_Fact_EndStation] FOREIGN KEY ([EndStationID])  REFERENCES [Station_Dim]([StationID]),
 CONSTRAINT [FK_Fact_StartDate] FOREIGN KEY ([StartDateID])  REFERENCES [Date_Dim]([DateID]),
 CONSTRAINT [FK_Fact_StartStation] FOREIGN KEY ([StartStationID])  REFERENCES [Station_Dim]([StationID]),
 CONSTRAINT [FK_Fact_Weather] FOREIGN KEY ([StartDateID])  REFERENCES [Weather_Dim]([DateID])
);
GO


CREATE NONCLUSTERED INDEX [FK_101] ON [Hire_Fact] 
 (
  [StartDateID] ASC
 )

GO

CREATE NONCLUSTERED INDEX [FK_33] ON [Hire_Fact] 
 (
  [StartStationID] ASC
 )

GO

CREATE NONCLUSTERED INDEX [FK_36] ON [Hire_Fact] 
 (
  [EndStationID] ASC
 )

GO

CREATE NONCLUSTERED INDEX [FK_43] ON [Hire_Fact] 
 (
  [BikeID] ASC
 )

GO

CREATE NONCLUSTERED INDEX [FK_82] ON [Hire_Fact] 
 (
  [StartDateID] ASC
 )

GO

CREATE NONCLUSTERED INDEX [FK_85] ON [Hire_Fact] 
 (
  [EndDateID] ASC
 )

GO
