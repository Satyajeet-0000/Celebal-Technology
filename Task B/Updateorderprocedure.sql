IF OBJECT_ID('UpdateOrderDetails') IS NOT NULL
    DROP PROCEDURE UpdateOrderDetails;
GO

CREATE PROCEDURE UpdateOrderDetails
    @SalesOrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(19, 4) = NULL,
    @OrderQty INT = NULL,
    @UnitPriceDiscount DECIMAL(19, 4) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @OldOrderQty INT;
    DECLARE @SafetyStockLevel INT;

    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Error: SalesOrderID ' + CAST(@SalesOrderID AS NVARCHAR(10)) + ' with ProductID ' + CAST(@ProductID AS NVARCHAR(10)) + ' does not exist.';
        RETURN;
    END;

    SELECT @OldOrderQty = sod.OrderQty
    FROM Sales.SalesOrderDetail AS sod
    WHERE sod.SalesOrderID = @SalesOrderID AND sod.ProductID = @ProductID;

    SELECT @SafetyStockLevel = p.SafetyStockLevel
    FROM Production.Product AS p
    WHERE p.ProductID = @ProductID;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- *** Stock Adjustment Logic (Conceptual for AdventureWorks) ***
        /*
        IF @OrderQty IS NOT NULL AND @OrderQty <> @OldOrderQty
        BEGIN
            DECLARE @OrderQtyChange INT = @OrderQty - @OldOrderQty;
            DECLARE @AvailableStockBeforeUpdate INT;

            SELECT @AvailableStockBeforeUpdate = SUM(Quantity)
            FROM Production.ProductInventory
            WHERE ProductID = @ProductID;

            IF @OrderQtyChange > 0 AND @AvailableStockBeforeUpdate < @OrderQtyChange
            BEGIN
                ROLLBACK TRANSACTION;
                PRINT 'Error: Insufficient stock to increase quantity for Product ' + CAST(@ProductID AS NVARCHAR(10)) + '.';
                RETURN;
            END;

            UPDATE Production.ProductInventory
            SET Quantity = Quantity - @OrderQtyChange
            WHERE ProductID = @ProductID AND LocationID = <AppropriateLocationID>;

            IF (@AvailableStockBeforeUpdate - @OrderQtyChange) < @SafetyStockLevel
            BEGIN
                PRINT 'Warning: Quantity in stock for Product ' + CAST(@ProductID AS NVARCHAR(10)) + ' has dropped below its reorder level (SafetyStockLevel).';
            END;
        END;
        */
        -- ***************************************************************

        UPDATE Sales.SalesOrderDetail
        SET
            UnitPrice = ISNULL(@UnitPrice, UnitPrice),
            OrderQty = ISNULL(@OrderQty, OrderQty),
            UnitPriceDiscount = ISNULL(@UnitPriceDiscount, UnitPriceDiscount)
        WHERE SalesOrderID = @SalesOrderID AND ProductID = @ProductID;

        COMMIT TRANSACTION;
        PRINT 'Sales order details updated successfully for SalesOrderID ' + CAST(@SalesOrderID AS NVARCHAR(10)) + ', ProductID ' + CAST(@ProductID AS NVARCHAR(10)) + '.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
        PRINT 'Failed to update sales order details. Please try again.';
    END CATCH;
END;
GO