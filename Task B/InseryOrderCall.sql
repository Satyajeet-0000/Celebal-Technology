USE AdventureWorks2019;
GO

EXEC UpdateOrderDetails
    @SalesOrderID = 43659, -- Use an existing SalesOrderID from Sales.SalesOrderDetail
    @ProductID = 711,      -- Use an existing ProductID associated with that SalesOrderID
    @OrderQty = 9;         -- New quantity
GO