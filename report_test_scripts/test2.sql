SELECT COUNT(HireID) FROM Hire_Fact join Weather_Dim on Hire_Fact.StartDateID = Weather_Dim.DateID
									join Station_Dim on Hire_Fact.StartStationID = Station_Dim.StationID
									where IsRain = 'Yes' and
										  Usertype = 'Customer' and
									      StartStationID = 2006;