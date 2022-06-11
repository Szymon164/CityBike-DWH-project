-- ************************************** [Date_Dim]
CREATE TABLE [Date_Dim]
(
 [DateID]              int NOT NULL ,
 [Date]                date NOT NULL ,
 [Day]                 tinyint NOT NULL ,
 [DaySuffix]           char(2) NOT NULL ,
 [Weekday]             tinyint NOT NULL ,
 [WeekDayName]         varchar(10) NOT NULL ,
 [IsWeekend]           bit NOT NULL ,
 [DayOfYear]           smallint NOT NULL ,
 [WeekOfMonth]         tinyint NOT NULL ,
 [WeekOfYear]          tinyint NOT NULL ,
 [Month]               tinyint NOT NULL ,
 [MonthName]           varchar(10) NOT NULL ,
 [Quarter]             tinyint NOT NULL ,
 [QuarterName]         varchar(6) NOT NULL ,
 [Year]                int NOT NULL ,
 [MMYYYY]              char(6) NOT NULL ,
 [MonthYear]           char(7) NOT NULL ,
 [FirstDayOfMonth]     date NOT NULL ,
 [LastDayOfMonth]      date NOT NULL ,
 [FirstDayOfQuarter]   date NOT NULL ,
 [LastDayOfQuarter]    date NOT NULL ,
 [FirstDayOfYear]      date NOT NULL ,
 [LastDayOfYear]       date NOT NULL ,
 [FirstDayOfNextMonth] date NOT NULL ,
 [FirstDayOfNextYear]  date NOT NULL ,


 CONSTRAINT [PK_DateDimension] PRIMARY KEY NONCLUSTERED ([DateID] ASC)
);
GO

DECLARE @Date DATETIME
DECLARE @EndDate DATETIME
SET @Date = '2013-01-01'
SET @EndDate = '2023-01-01'

WHILE @Date <= @EndDate
      BEGIN
             INSERT INTO [Date_Dim]
             SELECT
					REPLACE(@Date,'-','')       AS DateID,
                    @Date                       AS Date,
                    DAY(@Date)                  AS Day,
					CASE WHEN DAY(@Date) IN (1,21,31) THEN 'st' 
					WHEN DAY(@Date) IN (2,22) THEN 'nd'
					WHEN DAY(@Date) IN (3,23) THEN 'rd' 
					ELSE 'th' END               AS DaySuffix,
                    DATEPART(dw, @Date)         AS Weekday,
                    DATENAME(DAY, @Date)        AS WeekDayName,
                    DATEPART(dy, @Date)         AS DayOfYear,
                    DATEPART(wk, @Date)         AS WeekOfYear,
                    MONTH(@Date)                AS Month,
                    DATENAME(MONTH, @Date)      AS MonthName,
                    DATEPART(QUARTER, @Date)    AS Quarter,
                    DATENAME(QUARTER, @Date)    AS QuarterName,
                    YEAR(@Date)                 AS Year,
                    FORMAT(@Date, 'MMyyyy')     AS MMYYYY,
                    FORMAT(@Date, 'MM-yyyy')    AS MonthYear,
                    DATEFROMPARTS(YEAR(@Date),MONTH(@Date),1) AS FirstDayOfMonth,
                    EOMONTH(@Date)            AS LastDayOfMonth,
                    DATEADD(qq, DATEDIFF(qq, 0, @Date), 0) AS FirstDayOfQuarter,
                    DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @Date) + 1, 0)) AS LastDayOfQuarter,
                    DATEADD(yy, DATEDIFF(yy, 0, @Date), 0) AS FirstDayOfYear,
                    DATEADD (dd, -1, DATEADD(yy, DATEDIFF(yy, 0, @Date) + 1, 0)) AS LastDayOfYear,
                    DATEADD(d, 1, EOMONTH(@Date)) AS FirstDayOfMonth,
                    DATEADD(yy, DATEDIFF(yy, -1, @Date), 0) AS FirstDayOfNextYear

             SET @Date = DATEADD(dd, 1, @Date)
      END
GO