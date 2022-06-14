SELECT datepart(hour, StartTime) as Hour, Count(HireID) as "Number of hires"
from Hire_Fact
group by datepart(hour, StartTime)
order by datepart(hour, StartTime);