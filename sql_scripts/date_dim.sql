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
