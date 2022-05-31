
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
