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
CREATE TABLE [Date_Dim]
(
 [DateID]              int NOT NULL ,
 [Date]                date NOT NULL ,
 [Day]                 tinyint NOT NULL ,
 [DaySuffix]           char(2) NOT NULL ,
 [Weekday]             tinyint NOT NULL ,
 [WeekDayName]         varchar(10) NOT NULL ,
 [IsWeekend]           bit NOT NULL ,
 [IsHoliday]           bit NOT NULL ,
 [HolidayText]         varchar(64) SPARSE NULL ,
 [DOWInMonth]          tinyint NOT NULL ,
 [DayOfYear]           smallint NOT NULL ,
 [WeekOfMonth]         tinyint NOT NULL ,
 [WeekOfYear]          tinyint NOT NULL ,
 [ISOWeekOfYear]       tinyint NOT NULL ,
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
