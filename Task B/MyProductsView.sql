USE AdventureWorks2019; -- Make sure you're in the correct database
GO

IF OBJECT_ID('MyProducts') IS NOT NULL
    DROP VIEW MyProducts;
GO

CREATE VIEW MyProducts
AS
SELECT
    p.ProductID,
    p.Name AS ProductName,
    -- p.Weight AS QuantityPerUnit, -- AdventureWorks does not have a direct 'QuantityPerUnit' column like Northwind.
                                  -- p.Weight or p.Size could be conceptual placeholders.
    p.ListPrice AS UnitPrice,
    v.Name AS CompanyName,   -- Company Name from Purchasing.Vendor
    pc.Name AS CategoryName  -- CategoryName from Production.ProductCategory
FROM
    Production.Product AS p
JOIN
    Purchasing.ProductVendor AS ppv ON p.ProductID = ppv.ProductID -- New JOIN table
JOIN
    Purchasing.Vendor AS v ON ppv.BusinessEntityID = v.BusinessEntityID -- Corrected JOIN condition
JOIN
    Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN
    Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE
    p.DiscontinuedDate IS NULL; -- Products that are NOT discontinued have a NULL DiscontinuedDate
GO