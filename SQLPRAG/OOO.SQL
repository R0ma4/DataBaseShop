--use TechStore

--- 1 и 2 + Проверка состояния
SELECT 'Customers' AS TableName, COUNT(*) 'AS RowCount' FROM dbo.Customers
UNION ALL SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems;
SELECT
    SUM(Quantity) AS TotalUnits,
    SUM(CAST(Quantity AS DECIMAL(18,2)) * Prise) AS TotalRevenue
FROM dbo.OrderItems;


---- 5 
SELECT 
    CAST(OrderDate AS VARCHAR(8)) AS DateKey,
    DAY(OrderDate) AS 'День',
    'Квартар: ' + CAST(CEILING(MONTH(OrderDate) / 3.0) AS VARCHAR(1)) AS Quarter,
    FORMAT(OrderDate, 'MMMM', 'ru-RU') AS 'Месяц',
    YEAR(OrderDate) AS 'Год'
FROM (
    SELECT DISTINCT OrderDate
    FROM Orders
) AS UniqueOrders
ORDER BY OrderDate

--- 6 
SELECT [OrderItems].[OrderID] , [Orders].[OrderID]
FROM OrderItems
JOIN Orders ON [OrderItems].[OrderID] = [Orders].[OrderID] 

SELECT [OrderItems].[OrderID] , [Orders].[OrderID], [TechStore_DWH].[dbo].[DimCustomer].[CustomerID] , [TechStore_DWH].[dbo].[DimProduct].[ProductID], TechStore_DWH.dbo.DimDate.DateKey
FROM OrderItems
JOIN Orders ON [OrderItems].[OrderID] = [Orders].[OrderID] 
JOIN [TechStore_DWH].[dbo].[DimCustomer] ON [TechStore_DWH].[dbo].[DimCustomer].[CustomerID] = [TechStore_DWH].[dbo].[DimProduct].[ProductID]
JOIN [TechStore_DWH].[dbo].[DimProduct] ON [TechStore_DWH].[dbo].[DimProduct].[ProductID] = TechStore_DWH.dbo.DimDate.DateKey