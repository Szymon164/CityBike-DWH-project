SELECT AVG(TripDuration) FROM Hire_Fact JOIN Date_Dim on Hire_Fact.StartDateID = Date_Dim.DateID 
WHERE Date_Dim.WeekDayName = 'Monday' AND Hire_Fact.Usertype = 'Customer';

SELECT AVG(TripDuration) FROM Hire_Fact JOIN Date_Dim on Hire_Fact.StartDateID = Date_Dim.DateID
WHERE Date_Dim.WeekDayName = 'Monday' AND Hire_Fact.Usertype = 'Subscriber';