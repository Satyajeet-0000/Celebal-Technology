IF OBJECT_ID('GetOrderDetails') IS NOT NULL
    DROP PROCEDURE GetOrderDetails;
GO

CREATE PROCEDURE GetOrderDetails
    @SalesOrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT SalesOrderID AS OrderID, ProductID, UnitPrice, OrderQty AS Quantity, UnitPriceDiscount AS Discount
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID;

    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID)
    BEGIN
        PRINT 'The OrderID ' + CAST(@SalesOrderID AS NVARCHAR(10)) + ' does not exits';
        RETURN 1;
    END;

    RETURN 0;
END;
GO
