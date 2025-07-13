USE AdventureWorks2019;
GO

EXEC GetOrderDetails
    @SalesOrderID = 43659; -- Use an existing SalesOrderID from your Sales.SalesOrderDetail table
GO