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