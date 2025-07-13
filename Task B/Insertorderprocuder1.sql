USE AdventureWorks2019;
GO

EXEC InsertOrderDetails
    @SalesOrderID = 43659,    -- An existing SalesOrderID from Sales.SalesOrderHeader
    @ProductID = 707,         -- An existing ProductID from Production.Product
    @OrderQty = 5,
    @UnitPrice = 20.00,
    @UnitPriceDiscount = 0.05;
GO