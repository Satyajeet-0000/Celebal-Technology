USE AdventureWorks2019;
GO

-- First, check what you have (optional, but recommended)
SELECT TOP 5 SalesOrderID, ProductID, OrderQty
FROM Sales.SalesOrderDetail
ORDER BY SalesOrderID DESC; -- Or filter by a specific SalesOrderID

-- Then, execute the delete procedure
EXEC DeleteOrderDetails
    @SalesOrderID = 43659, -- Replace with an existing SalesOrderID
    @ProductID = 707;      -- Replace with an existing ProductID associated with that SalesOrderID
GO