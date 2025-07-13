USE AdventureWorks2019; -- IMPORTANT: Make sure this is the correct database name you are using.
GO

IF OBJECT_ID('vwCustomerOrders') IS NOT NULL
    DROP VIEW vwCustomerOrders;
GO

CREATE VIEW vwCustomerOrders
AS
SELECT
    c.AccountNumber AS CompanyName,
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    (sod.OrderQty * sod.UnitPrice) AS TotalLinePrice
FROM
    Sales.Customer AS c -- *** THIS IS THE CRITICAL LINE: IT MUST BE 'Sales.Customer' ***
JOIN
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
JOIN
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN
    Production.Product AS p ON sod.ProductID = p.ProductID;
GO