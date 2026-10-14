USE TechStore;
GO
SET XACT_ABORT ON;
GO

IF SCHEMA_ID(N'stg') IS NULL
    EXEC(N'CREATE SCHEMA stg');
GO

DROP TABLE IF EXISTS stg.ProductsImportRaw;
GO

CREATE TABLE stg.ProductsImportRaw (
    ProductID NVARCHAR(50) NULL,
    ProductName NVARCHAR(200) NULL,
    Category NVARCHAR(100) NULL,
    Price NVARCHAR(100) NULL
);
GO

BULK INSERT stg.ProductsImportRaw
FROM 'C:\TechStoreImport\02_Products_import.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

SELECT * FROM stg.ProductsImportRaw;
GO

SELECT
    TRY_CONVERT(INT, TRIM(ProductID)) AS ProductID,
    TRIM(ProductName) AS ProductName,
    TRIM(Category) AS Category,
    TRY_CONVERT(
        DECIMAL(12,2),
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(REPLACE(TRIM(Price), CHAR(13), N''), N'₽', N''),
                    NCHAR(160), N''
                ),
                N' ', N''
            ),
            N',', N'.'
        )
    ) AS Price
FROM stg.ProductsImportRaw;
GO

WITH Clean AS (
    SELECT
        TRY_CONVERT(INT, TRIM(ProductID)) AS ProductID,
        TRIM(ProductName) AS ProductName,
        TRIM(Category) AS Category,
        TRY_CONVERT(
            DECIMAL(12,2),
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(Price), CHAR(13), N''), N'₽', N''), NCHAR(160), N''), N' ', N''), N',', N'.')
        ) AS Price
    FROM stg.ProductsImportRaw
)
SELECT *
FROM Clean
WHERE ProductID IS NULL
   OR NULLIF(ProductName, N'') IS NULL
   OR NULLIF(Category, N'') IS NULL
   OR Price IS NULL
   OR Price < 0;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    SET IDENTITY_INSERT dbo.Products ON;

    INSERT INTO dbo.Products (ProductID, ProductName, Category, Price)
    SELECT
        TRY_CONVERT(INT, TRIM(r.ProductID)),
        TRIM(r.ProductName),
        TRIM(r.Category),
        TRY_CONVERT(
            DECIMAL(12,2),
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(r.Price), CHAR(13), N''), N'₽', N''), NCHAR(160), N''), N' ', N''), N',', N'.')
        )
    FROM stg.ProductsImportRaw AS r
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Products AS p
        WHERE p.ProductID = TRY_CONVERT(INT, TRIM(r.ProductID))
    );

    SET IDENTITY_INSERT dbo.Products OFF;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF OBJECTPROPERTY(OBJECT_ID(N'dbo.Products'), 'TableHasIdentity') = 1
    BEGIN TRY
        SET IDENTITY_INSERT dbo.Products OFF;
    END TRY
    BEGIN CATCH
    END CATCH;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

SELECT *
FROM dbo.Products
WHERE ProductID BETWEEN 16 AND 20
ORDER BY ProductID;

SELECT COUNT(*) AS ProductsAfterImport
FROM dbo.Products;

GO
