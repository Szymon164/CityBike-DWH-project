-- ************************************** [Bike_Dim]
CREATE TABLE [Bike_Dim]
(
 [BikeID]          int NOT NULL ,
 [BikeType]        varchar(50) NOT NULL ,
 [LastServiceDate] date NOT NULL ,


 CONSTRAINT [PK_39] PRIMARY KEY CLUSTERED ([BikeID] ASC)
);
GO