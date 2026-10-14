/*
RideWave_DWH — учебное аналитическое хранилище для мини-практики по Data Mart.
Предметная область: городской сервис аренды велосипедов и электросамокатов.

Гранулярность FactTrips:
1 строка = 1 завершённая поездка.

Скрипт рассчитан на SQL Server / SSMS.
ВНИМАНИЕ: при повторном запуске база RideWave_DWH пересоздаётся.
*/

USE master;
GO

IF DB_ID(N'RideWave_DWH') IS NOT NULL
BEGIN
    ALTER DATABASE RideWave_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RideWave_DWH;
END;
GO

CREATE DATABASE RideWave_DWH;
GO

USE RideWave_DWH;
GO

CREATE TABLE dbo.DimDate (
    DateKey      INT           NOT NULL PRIMARY KEY,
    FullDate     DATE          NOT NULL UNIQUE,
    [Year]       SMALLINT      NOT NULL,
    MonthNumber  TINYINT       NOT NULL,
    MonthName    NVARCHAR(20)  NOT NULL
);
GO

CREATE TABLE dbo.DimZone (
    ZoneKey      INT            NOT NULL PRIMARY KEY,
    ZoneName     NVARCHAR(100)  NOT NULL,
    District     NVARCHAR(50)   NOT NULL
);
GO

CREATE TABLE dbo.DimVehicleType (
    VehicleTypeKey   INT            NOT NULL PRIMARY KEY,
    VehicleTypeName  NVARCHAR(50)   NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.DimCustomer (
    CustomerKey  INT            NOT NULL PRIMARY KEY,
    CustomerID   INT            NOT NULL UNIQUE,
    Segment      NVARCHAR(30)   NOT NULL,
    City         NVARCHAR(50)   NOT NULL
);
GO

CREATE TABLE dbo.FactTrips (
    TripKey          INT            NOT NULL PRIMARY KEY,
    DateKey          INT            NOT NULL,
    ZoneKey          INT            NOT NULL,
    VehicleTypeKey   INT            NOT NULL,
    CustomerKey      INT            NOT NULL,
    TripID           INT            NOT NULL UNIQUE,
    DurationMinutes  INT            NOT NULL CHECK (DurationMinutes > 0),
    DistanceKm       DECIMAL(8,2)   NOT NULL CHECK (DistanceKm > 0),
    Amount           DECIMAL(10,2)  NOT NULL CHECK (Amount >= 0),

    CONSTRAINT FK_FactTrips_DimDate
        FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey),

    CONSTRAINT FK_FactTrips_DimZone
        FOREIGN KEY (ZoneKey) REFERENCES dbo.DimZone(ZoneKey),

    CONSTRAINT FK_FactTrips_DimVehicleType
        FOREIGN KEY (VehicleTypeKey) REFERENCES dbo.DimVehicleType(VehicleTypeKey),

    CONSTRAINT FK_FactTrips_DimCustomer
        FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomer(CustomerKey)
);
GO

INSERT INTO dbo.DimDate (DateKey, FullDate, [Year], MonthNumber, MonthName)
VALUES
(20260105, '2026-01-05', 2026, 1, N'Январь'),
(20260112, '2026-01-12', 2026, 1, N'Январь'),
(20260119, '2026-01-19', 2026, 1, N'Январь'),
(20260126, '2026-01-26', 2026, 1, N'Январь'),
(20260130, '2026-01-30', 2026, 1, N'Январь'),
(20260203, '2026-02-03', 2026, 2, N'Февраль'),
(20260210, '2026-02-10', 2026, 2, N'Февраль'),
(20260217, '2026-02-17', 2026, 2, N'Февраль'),
(20260224, '2026-02-24', 2026, 2, N'Февраль'),
(20260228, '2026-02-28', 2026, 2, N'Февраль'),
(20260304, '2026-03-04', 2026, 3, N'Март'),
(20260311, '2026-03-11', 2026, 3, N'Март'),
(20260318, '2026-03-18', 2026, 3, N'Март'),
(20260325, '2026-03-25', 2026, 3, N'Март'),
(20260330, '2026-03-30', 2026, 3, N'Март'),
(20260402, '2026-04-02', 2026, 4, N'Апрель'),
(20260409, '2026-04-09', 2026, 4, N'Апрель'),
(20260416, '2026-04-16', 2026, 4, N'Апрель'),
(20260423, '2026-04-23', 2026, 4, N'Апрель'),
(20260429, '2026-04-29', 2026, 4, N'Апрель');
GO

INSERT INTO dbo.DimZone (ZoneKey, ZoneName, District)
VALUES
(1, N'Central Square', N'Center'),
(2, N'Riverside', N'West'),
(3, N'University', N'North'),
(4, N'Old Town', N'South'),
(5, N'Business Park', N'East');
GO

INSERT INTO dbo.DimVehicleType (VehicleTypeKey, VehicleTypeName)
VALUES
(1, N'E-Scooter'),
(2, N'E-Bike'),
(3, N'Bike');
GO

INSERT INTO dbo.DimCustomer (CustomerKey, CustomerID, Segment, City)
VALUES
(1, 1001, N'Standard', N'Almaty'),
(2, 1002, N'Student', N'Almaty'),
(3, 1003, N'Business', N'Almaty'),
(4, 1004, N'Standard', N'Almaty'),
(5, 1005, N'Tourist', N'Astana'),
(6, 1006, N'Student', N'Almaty'),
(7, 1007, N'Business', N'Almaty'),
(8, 1008, N'Standard', N'Shymkent'),
(9, 1009, N'Tourist', N'Bishkek'),
(10, 1010, N'Standard', N'Almaty');
GO

INSERT INTO dbo.FactTrips (
    TripKey, DateKey, ZoneKey, VehicleTypeKey, CustomerKey,
    TripID, DurationMinutes, DistanceKm, Amount
)
VALUES
(1, 20260105, 1, 1, 1, 50001, 8, 2.44, 4.80),
(2, 20260105, 3, 2, 3, 50002, 17, 4.34, 7.10),
(3, 20260105, 5, 3, 5, 50003, 26, 6.51, 5.68),
(4, 20260105, 2, 1, 7, 50004, 35, 7.38, 13.75),
(5, 20260112, 2, 2, 4, 50005, 15, 4.00, 6.50),
(6, 20260112, 4, 3, 6, 50006, 24, 6.14, 5.32),
(7, 20260112, 1, 1, 8, 50007, 33, 7.07, 13.55),
(8, 20260112, 3, 2, 10, 50008, 42, 8.34, 14.60),
(9, 20260119, 3, 3, 7, 50009, 22, 5.77, 4.96),
(10, 20260119, 5, 1, 9, 50010, 31, 6.76, 12.35),
(11, 20260119, 2, 2, 1, 50011, 40, 8.00, 14.00),
(12, 20260119, 4, 3, 3, 50012, 14, 4.04, 3.52),
(13, 20260126, 4, 1, 10, 50013, 29, 6.45, 11.65),
(14, 20260126, 1, 2, 2, 50014, 38, 7.66, 13.90),
(15, 20260126, 3, 3, 4, 50015, 12, 3.67, 3.16),
(16, 20260126, 5, 1, 6, 50016, 21, 4.96, 8.85),
(17, 20260130, 5, 2, 3, 50017, 36, 7.32, 12.80),
(18, 20260130, 2, 3, 5, 50018, 10, 3.30, 2.80),
(19, 20260130, 4, 1, 7, 50019, 19, 4.65, 8.15),
(20, 20260130, 1, 2, 9, 50020, 28, 6.71, 10.90),
(21, 20260203, 1, 3, 6, 50021, 8, 2.93, 2.94),
(22, 20260203, 3, 1, 8, 50022, 17, 4.34, 7.45),
(23, 20260203, 5, 2, 10, 50023, 26, 6.37, 9.80),
(24, 20260203, 2, 3, 2, 50024, 35, 7.67, 7.30),
(25, 20260210, 2, 1, 9, 50025, 15, 4.03, 6.75),
(26, 20260210, 4, 2, 1, 50026, 24, 6.03, 9.20),
(27, 20260210, 1, 3, 3, 50027, 33, 7.30, 7.44),
(28, 20260210, 3, 1, 5, 50028, 42, 7.96, 16.20),
(29, 20260217, 3, 2, 2, 50029, 22, 5.69, 8.60),
(30, 20260217, 5, 3, 4, 50030, 31, 6.94, 6.58),
(31, 20260217, 2, 1, 6, 50031, 40, 7.65, 15.50),
(32, 20260217, 4, 2, 8, 50032, 14, 4.08, 6.20),
(33, 20260224, 4, 3, 5, 50033, 29, 6.57, 6.22),
(34, 20260224, 1, 1, 7, 50034, 38, 7.34, 15.30),
(35, 20260224, 3, 2, 9, 50035, 12, 3.74, 5.60),
(36, 20260224, 5, 3, 1, 50036, 21, 5.83, 4.78),
(37, 20260228, 5, 1, 8, 50037, 36, 7.03, 14.10),
(38, 20260228, 2, 2, 10, 50038, 10, 3.40, 5.00),
(39, 20260228, 4, 3, 2, 50039, 19, 5.46, 4.42),
(40, 20260228, 1, 1, 4, 50040, 28, 5.54, 11.80),
(41, 20260304, 1, 2, 1, 50041, 8, 3.06, 4.90),
(42, 20260304, 3, 3, 3, 50042, 17, 5.09, 4.06),
(43, 20260304, 5, 1, 5, 50043, 26, 5.23, 10.60),
(44, 20260304, 2, 2, 7, 50044, 35, 7.40, 12.50),
(45, 20260311, 2, 3, 4, 50045, 15, 4.72, 3.70),
(46, 20260311, 4, 1, 6, 50046, 24, 4.92, 9.90),
(47, 20260311, 1, 2, 8, 50047, 33, 7.06, 12.40),
(48, 20260311, 3, 3, 10, 50048, 42, 9.47, 8.56),
(49, 20260318, 3, 1, 7, 50049, 22, 4.61, 9.20),
(50, 20260318, 5, 2, 9, 50050, 31, 6.72, 11.30),
(51, 20260318, 2, 3, 1, 50051, 40, 9.10, 8.20),
(52, 20260318, 4, 1, 3, 50052, 14, 4.12, 6.40),
(53, 20260325, 4, 2, 10, 50053, 29, 6.38, 10.70),
(54, 20260325, 1, 3, 2, 50054, 38, 8.73, 8.34),
(55, 20260325, 3, 1, 4, 50055, 12, 3.81, 5.70),
(56, 20260325, 5, 2, 6, 50056, 21, 4.77, 8.30),
(57, 20260330, 5, 3, 3, 50057, 36, 8.36, 7.48),
(58, 20260330, 2, 1, 5, 50058, 10, 3.50, 5.00),
(59, 20260330, 4, 2, 7, 50059, 19, 4.43, 7.70),
(60, 20260330, 1, 3, 9, 50060, 28, 6.63, 6.54),
(61, 20260402, 1, 1, 6, 50061, 8, 3.19, 4.80),
(62, 20260402, 3, 2, 8, 50062, 17, 4.09, 7.10),
(63, 20260402, 5, 3, 10, 50063, 26, 6.26, 5.68),
(64, 20260402, 2, 1, 2, 50064, 35, 7.13, 13.75),
(65, 20260409, 2, 2, 9, 50065, 15, 3.75, 6.50),
(66, 20260409, 4, 3, 1, 50066, 24, 5.89, 5.32),
(67, 20260409, 1, 1, 3, 50067, 33, 6.82, 13.55),
(68, 20260409, 3, 2, 5, 50068, 42, 9.09, 14.60),
(69, 20260416, 3, 3, 2, 50069, 22, 5.52, 4.96),
(70, 20260416, 5, 1, 4, 50070, 31, 6.51, 12.35),
(71, 20260416, 2, 2, 6, 50071, 40, 8.75, 14.00),
(72, 20260416, 4, 3, 8, 50072, 14, 3.79, 3.52),
(73, 20260423, 4, 1, 5, 50073, 29, 6.20, 11.65),
(74, 20260423, 1, 2, 7, 50074, 38, 8.41, 13.90),
(75, 20260423, 3, 3, 9, 50075, 12, 3.42, 3.16),
(76, 20260423, 5, 1, 1, 50076, 21, 4.71, 8.85),
(77, 20260429, 5, 2, 8, 50077, 36, 8.07, 12.80),
(78, 20260429, 2, 3, 10, 50078, 10, 3.05, 2.80),
(79, 20260429, 4, 1, 2, 50079, 19, 4.40, 8.15),
(80, 20260429, 1, 2, 4, 50080, 28, 6.46, 10.90);
GO

-- Контроль исходного DWH
SELECT 'DimDate' AS ObjectName, COUNT(*) AS RowCount FROM dbo.DimDate
UNION ALL
SELECT 'DimZone', COUNT(*) FROM dbo.DimZone
UNION ALL
SELECT 'DimVehicleType', COUNT(*) FROM dbo.DimVehicleType
UNION ALL
SELECT 'DimCustomer', COUNT(*) FROM dbo.DimCustomer
UNION ALL
SELECT 'FactTrips', COUNT(*) FROM dbo.FactTrips;
GO

SELECT
    COUNT(*) AS Trips,
    SUM(DurationMinutes) AS TotalMinutes,
    CAST(SUM(DistanceKm) AS DECIMAL(12,2)) AS TotalDistanceKm,
    CAST(SUM(Amount) AS DECIMAL(12,2)) AS Revenue
FROM dbo.FactTrips;
GO

-- Ожидается:
-- DimDate = 20
-- DimZone = 5
-- DimVehicleType = 3
-- DimCustomer = 10
-- FactTrips = 80
-- Trips = 80
-- TotalMinutes = 2000
-- TotalDistanceKm = 465.03
-- Revenue = 689.34
