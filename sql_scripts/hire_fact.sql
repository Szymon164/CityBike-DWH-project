-- ************************************** [Hire_Fact]
CREATE TABLE [Hire_Fact]
(
 [HireID]          NOT NULL ,
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
