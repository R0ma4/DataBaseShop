
USE RideWave_DWH;
GO

-- 

--год
--номер месяца
--название месяца
--район
--количество поездок
--суммарная длительность
--суммарное расстояние
--выручка
--средняя выручка на поездку

CREATE OR ALTER VIEW mart.vw_MonthlyDistrictPerformance 
AS 
	Select Year as 'Год',
		MonthNumber as 'Номер месяца',
		MonthName as 'Название месяца',
		District as 'Раён',
		COUNT(f.TripKey) as 'Всего поездок',
		SUM(f.DurationMinutes) / COUNT(f.TripKey)  as 'Суммараня длительность',
		SUM(f.Amount) 'Выручка',
		ROUND((SUM(f.Amount) / COUNT(f.TripKey)),2)  as 'Средняя выручка на поездку'
	from dbo.FactTrips as f
	JOIN dbo.DimDate as d ON d.DateKey = f.DateKey
	JOIN dbo.DimZone as z ON z.ZoneKey = f.ZoneKey
	GROUP BY d.Year, d.MonthName, d.MonthNumber, z.District




select *
from mart.vw_MonthlyDistrictPerformance 

select  
	mdp.Год,
	mdp.[Номер месяца],
	mdp.[Название месяца],
	mdp.Раён,
	mdp.Выручка
from mart.vw_MonthlyDistrictPerformance as mdp


-- Сортировка перевёртыш
select  
	mdp.Год,
	mdp.[Номер месяца],
	mdp.[Название месяца],
	mdp.Раён,
	mdp.Выручка
from mart.vw_MonthlyDistrictPerformance as mdp
ORDER BY Выручка DESC


-- Выше среднего
select  
	mdp.Год,
	mdp.[Номер месяца],
	mdp.[Название месяца],
	mdp.Раён,
	mdp.Выручка
from mart.vw_MonthlyDistrictPerformance as mdp
WHERE Выручка > (
	SELECT AVG([Средняя выручка на поездку]) 
	from mart.vw_MonthlyDistrictPerformance
)
ORDER BY Выручка DESC


-- Найдите район с максимальной общей выручкой за весь период.
select  
	mdp.Раён,Выручка
from mart.vw_MonthlyDistrictPerformance as mdp
WHERE Выручка > mdp.[Средняя выручка на поездку]
ORDER BY Выручка DESC

