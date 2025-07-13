USE AdventureWorks2019;
GO

-- To test the insertion via the trigger:
-- This will attempt to insert a new sales order detail,
-- and the trigger will intercept it.
EXEC InsertOrderDetails
    @SalesOrderID = 43659, -- Use an existing SalesOrderID
    @ProductID = 707,      -- Use an existing ProductID
    @OrderQty = 3,         -- Specify quantity
    @UnitPrice = 20.00,
    @UnitPriceDiscount = 0.00;
GO

-- Verify the insertion (if successful):
SELECT SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43659 AND ProductID = 707
ORDER BY ModifiedDate DESC; -- Look for the most recent entry if multiple
GO