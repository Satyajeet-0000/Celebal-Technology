USE AdventureWorks2019; -- Replace with the actual name of your restored AdventureWorks database
GO

IF OBJECT_ID('vwCustomerOrders') IS NOT NULL
    DROP VIEW vwCustomerOrders;
GO

CREATE VIEW vwCustomerOrders
AS
SELECT
    c.AccountNumber AS CompanyName, -- Using AccountNumber as a representation of CompanyName for Sales.Customer
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    (sod.OrderQty * sod.UnitPrice) AS TotalLinePrice
FROM
    Sales.Customer AS c -- This is the corrected table name
JOIN
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
JOIN
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN
    Production.Product AS p ON sod.ProductID = p.ProductID;
GO