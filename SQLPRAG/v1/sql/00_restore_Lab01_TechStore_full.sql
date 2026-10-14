USE master;
GO

IF DB_ID(N'TechStore_DWH') IS NOT NULL
BEGIN
    ALTER DATABASE TechStore_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TechStore_DWH;
END;
GO

IF DB_ID(N'TechStore') IS NOT NULL
BEGIN
    ALTER DATABASE TechStore SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TechStore;
END;
GO

CREATE DATABASE TechStore;
GO
USE TechStore;
GO

CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Customers PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NULL,
    City NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Products PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(100) NOT NULL,
    Price DECIMAL(12,2) NOT NULL,
    CONSTRAINT CK_Products_Price CHECK (Price >= 0)
);

CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);

CREATE TABLE dbo.OrderItems (
    OrderItemID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_OrderItems PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(12,2) NOT NULL,
    CONSTRAINT CK_OrderItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_OrderItems_Price CHECK (Price >= 0),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO

SET IDENTITY_INSERT dbo.Customers ON;
INSERT INTO dbo.Customers (CustomerID, FirstName, LastName, Email, City) VALUES
(1, N'Иван', N'Иванов', 'ivan@example.com', N'Москва'),
(2, N'Пётр', N'Петров', 'petr@example.com', N'Санкт-Петербург'),
(3, N'Анна', N'Смирнова', 'anna@example.com', N'Казань'),
(4, N'Мария', N'Кузнецова', 'maria@example.com', N'Москва'),
(5, N'Алексей', N'Попов', 'alexey@example.com', N'Екатеринбург'),
(6, N'Елена', N'Васильева', 'elena@example.com', N'Новосибирск'),
(7, N'Дмитрий', N'Соколов', 'dmitry@example.com', N'Москва'),
(8, N'Ольга', N'Морозова', 'olga@example.com', N'Казань'),
(9, N'Сергей', N'Волков', 'sergey@example.com', N'Екатеринбург'),
(10, N'Наталья', N'Фёдорова', 'natalia@example.com', N'Санкт-Петербург');
SET IDENTITY_INSERT dbo.Customers OFF;

SET IDENTITY_INSERT dbo.Products ON;
INSERT INTO dbo.Products (ProductID, ProductName, Category, Price) VALUES
(1, N'Ноутбук Pro 14', N'Ноутбуки', 120000),
(2, N'Ноутбук Air 13', N'Ноутбуки', 90000),
(3, N'Монитор 27', N'Мониторы', 35000),
(4, N'Монитор 24', N'Мониторы', 22000),
(5, N'Клавиатура Механическая', N'Периферия', 8000),
(6, N'Мышь Gaming', N'Периферия', 5000),
(7, N'Наушники Pro', N'Аудио', 15000),
(8, N'Веб-камера HD', N'Периферия', 7000),
(9, N'SSD 1TB', N'Накопители', 10000),
(10, N'SSD 2TB', N'Накопители', 18000),
(11, N'HDD 2TB', N'Накопители', 9000),
(12, N'Планшет 10', N'Планшеты', 30000),
(13, N'Смартфон Pro', N'Смартфоны', 70000),
(14, N'Смартфон Lite', N'Смартфоны', 40000),
(15, N'Док-станция USB-C', N'Периферия', 12000);
SET IDENTITY_INSERT dbo.Products OFF;

SET IDENTITY_INSERT dbo.Orders ON;
INSERT INTO dbo.Orders (OrderID, CustomerID, OrderDate) VALUES
(1001, 1, '2026-01-10'),
(1002, 2, '2026-01-15'),
(1003, 3, '2026-01-20'),
(1004, 1, '2026-02-05'),
(1005, 4, '2026-02-12'),
(1006, 5, '2026-02-20'),
(1007, 6, '2026-03-03'),
(1008, 7, '2026-03-10'),
(1009, 8, '2026-03-15'),
(1010, 9, '2026-03-25'),
(1011, 10, '2026-04-02'),
(1012, 2, '2026-04-12'),
(1013, 3, '2026-04-20'),
(1014, 4, '2026-05-05'),
(1015, 5, '2026-05-18'),
(1016, 1, '2026-06-01'),
(1017, 6, '2026-06-15'),
(1018, 7, '2026-07-10'),
(1019, 8, '2026-08-05'),
(1020, 10, '2026-09-01');
SET IDENTITY_INSERT dbo.Orders OFF;

SET IDENTITY_INSERT dbo.OrderItems ON;
INSERT INTO dbo.OrderItems (OrderItemID, OrderID, ProductID, Quantity, Price) VALUES
(1, 1001, 1, 1, 120000),
(2, 1001, 5, 1, 8000),
(3, 1001, 6, 1, 5000),
(4, 1002, 2, 1, 90000),
(5, 1002, 7, 1, 15000),
(6, 1003, 3, 2, 35000),
(7, 1003, 5, 1, 8000),
(8, 1004, 13, 1, 70000),
(9, 1004, 9, 1, 10000),
(10, 1005, 4, 1, 22000),
(11, 1005, 8, 1, 7000),
(12, 1005, 6, 2, 5000),
(13, 1006, 12, 1, 30000),
(14, 1006, 10, 1, 18000),
(15, 1007, 1, 1, 120000),
(16, 1007, 7, 1, 15000),
(17, 1008, 2, 2, 90000),
(18, 1008, 6, 1, 5000),
(19, 1009, 13, 1, 70000),
(20, 1009, 14, 1, 40000),
(21, 1010, 3, 1, 35000),
(22, 1010, 4, 1, 22000),
(23, 1010, 5, 1, 8000),
(24, 1011, 11, 1, 9000),
(25, 1011, 9, 2, 10000),
(26, 1012, 1, 1, 120000),
(27, 1012, 15, 1, 12000),
(28, 1013, 12, 2, 30000),
(29, 1013, 8, 1, 7000),
(30, 1014, 13, 1, 70000),
(31, 1014, 7, 1, 15000),
(32, 1015, 2, 1, 90000),
(33, 1015, 10, 1, 18000),
(34, 1016, 1, 1, 120000),
(35, 1016, 3, 1, 35000),
(36, 1017, 14, 1, 40000),
(37, 1017, 6, 2, 5000),
(38, 1018, 2, 1, 90000),
(39, 1018, 5, 1, 8000),
(40, 1019, 13, 1, 70000),
(41, 1019, 9, 1, 10000),
(42, 1020, 1, 1, 120000),
(43, 1020, 15, 1, 12000);
SET IDENTITY_INSERT dbo.OrderItems OFF;
GO

SELECT 'Customers' AS TableName, COUNT(*) AS RowCount FROM dbo.Customers
UNION ALL SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems;

SELECT
    SUM(Quantity) AS TotalUnits,
    SUM(CAST(Quantity AS DECIMAL(18,2)) * Price) AS TotalRevenue
FROM dbo.OrderItems;
GO

CREATE DATABASE TechStore_DWH;
GO
USE TechStore_DWH;
GO

CREATE TABLE dbo.DimCustomer (
    CustomerKey INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimCustomer PRIMARY KEY,
    CustomerID INT NOT NULL CONSTRAINT UQ_DimCustomer_CustomerID UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    City NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.DimProduct (
    ProductKey INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimProduct PRIMARY KEY,
    ProductID INT NOT NULL CONSTRAINT UQ_DimProduct_ProductID UNIQUE,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.DimDate (
    DateKey INT NOT NULL CONSTRAINT PK_DimDate PRIMARY KEY,
    FullDate DATE NOT NULL CONSTRAINT UQ_DimDate_FullDate UNIQUE,
    [Day] INT NOT NULL,
    [Month] INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    [Quarter] INT NOT NULL,
    [Year] INT NOT NULL
);

CREATE TABLE dbo.FactSales (
    SalesKey INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_FactSales PRIMARY KEY,
    OrderID INT NOT NULL,
    DateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(12,2) NOT NULL,
    Amount DECIMAL(12,2) NOT NULL,
    CONSTRAINT CK_FactSales_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_FactSales_Price CHECK (Price >= 0),
    CONSTRAINT CK_FactSales_Amount CHECK (Amount >= 0),
    CONSTRAINT FK_FactSales_DimDate FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey),
    CONSTRAINT FK_FactSales_DimCustomer FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_DimProduct FOREIGN KEY (ProductKey) REFERENCES dbo.DimProduct(ProductKey)
);
GO

INSERT INTO dbo.DimCustomer (CustomerID, FirstName, LastName, City)
SELECT CustomerID, FirstName, LastName, City
FROM TechStore.dbo.Customers;

INSERT INTO dbo.DimProduct (ProductID, ProductName, Category)
SELECT ProductID, ProductName, Category
FROM TechStore.dbo.Products;

INSERT INTO dbo.DimDate (DateKey, FullDate, [Day], [Month], MonthName, [Quarter], [Year])
SELECT DISTINCT
    CONVERT(INT, CONVERT(CHAR(8), o.OrderDate, 112)),
    o.OrderDate,
    DAY(o.OrderDate),
    MONTH(o.OrderDate),
    FORMAT(o.OrderDate, N'MMMM', 'ru-RU'),
    DATEPART(QUARTER, o.OrderDate),
    YEAR(o.OrderDate)
FROM TechStore.dbo.Orders AS o;

INSERT INTO dbo.FactSales (OrderID, DateKey, CustomerKey, ProductKey, Quantity, Price, Amount)
SELECT
    oi.OrderID,
    dd.DateKey,
    dc.CustomerKey,
    dp.ProductKey,
    oi.Quantity,
    oi.Price,
    CAST(oi.Quantity * oi.Price AS DECIMAL(12,2))
FROM TechStore.dbo.OrderItems AS oi
JOIN TechStore.dbo.Orders AS o ON o.OrderID = oi.OrderID
JOIN dbo.DimCustomer AS dc ON dc.CustomerID = o.CustomerID
JOIN dbo.DimProduct AS dp ON dp.ProductID = oi.ProductID
JOIN dbo.DimDate AS dd ON dd.FullDate = o.OrderDate;
GO

SELECT 'DimCustomer' AS TableName, COUNT(*) AS RowCount FROM dbo.DimCustomer
UNION ALL SELECT 'DimProduct', COUNT(*) FROM dbo.DimProduct
UNION ALL SELECT 'DimDate', COUNT(*) FROM dbo.DimDate
UNION ALL SELECT 'FactSales', COUNT(*) FROM dbo.FactSales;

SELECT SUM(Quantity) AS TotalUnits, SUM(Amount) AS TotalRevenue
FROM dbo.FactSales;
GO

SELECT
    p.ProductName,
    SUM(f.Quantity) AS UnitsSold,
    SUM(f.Amount) AS Revenue
FROM dbo.FactSales AS f
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
GROUP BY p.ProductKey, p.ProductName
ORDER BY Revenue DESC, p.ProductName;

SELECT p.Category, SUM(f.Amount) AS Revenue
FROM dbo.FactSales AS f
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
GROUP BY p.Category
ORDER BY Revenue DESC, p.Category;

SELECT c.FirstName, c.LastName, SUM(f.Amount) AS TotalSpent
FROM dbo.FactSales AS f
JOIN dbo.DimCustomer AS c ON c.CustomerKey = f.CustomerKey
GROUP BY c.CustomerKey, c.FirstName, c.LastName
ORDER BY TotalSpent DESC, c.LastName, c.FirstName;

SELECT d.[Year], d.[Month], d.MonthName, SUM(f.Amount) AS Revenue
FROM dbo.FactSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.DateKey
GROUP BY d.[Year], d.[Month], d.MonthName
ORDER BY d.[Year], d.[Month];
GO
