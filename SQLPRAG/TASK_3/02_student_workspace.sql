/*
RideWave_DWH — рабочий файл студента.
Сначала выполните 01_setup_RideWave_DWH.sql.

Не заполняйте этот файл механически.
Сначала определите потребителя, вопросы, показатели, измерения и гранулярность витрины.
*/

USE RideWave_DWH;
GO

IF SCHEMA_ID(N'mart') IS NULL
    EXEC(N'CREATE SCHEMA mart');
GO

/* =========================================================
   Задание 1. Основная логическая витрина
   mart.vw_MonthlyDistrictPerformance

   Требуемые поля:
   Year
   MonthNumber
   MonthName
   District
   TripsCount
   TotalMinutes
   TotalDistanceKm
   Revenue
   AvgRevenuePerTrip

   Гранулярность:
   1 строка = один месяц + один район.
   ========================================================= */

-- CREATE OR ALTER VIEW mart.vw_MonthlyDistrictPerformance
-- AS
-- SELECT ...
-- GO


/* =========================================================
   Задание 2. Запросы к готовой витрине

-- 2.1. Выведите месяцы и районы по убыванию Revenue.

-- 2.2. Выведите только строки, где Revenue выше среднего
--      значения Revenue по строкам витрины.

-- 2.3. Найдите район с максимальной общей Revenue
--      за весь период (агрегация поверх витрины).
========================================================= */

/* =========================================================
   Дополнительное задание
   mart.vw_VehicleTypePerformance

   Поля:
   VehicleTypeName
   TripsCount
   TotalMinutes
   TotalDistanceKm
   Revenue
   AvgTripMinutes
   ========================================================= */

-- CREATE OR ALTER VIEW mart.vw_VehicleTypePerformance
-- AS
-- SELECT ...
-- GO


-- Самопроверка объектов

SELECT
    s.name AS SchemaName,
    v.name AS ViewName
FROM sys.views AS v
JOIN sys.schemas AS s
    ON s.schema_id = v.schema_id
WHERE s.name = N'mart'
ORDER BY v.name;
GO
