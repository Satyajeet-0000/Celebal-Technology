IF OBJECT_ID('DeleteOrderDetails') IS NOT NULL
    DROP PROCEDURE DeleteOrderDetails;
GO

CREATE PROCEDURE DeleteOrderDetails
    @SalesOrderID INT,
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Error: Invalid parameters. The given SalesOrder ID or Product ID does not exist in the specified sales order.';
        RETURN -1;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM Sales.SalesOrderDetail
        WHERE SalesOrderID = @SalesOrderID AND ProductID = @ProductID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Failed to delete the sales order detail. Please try again.', 16, 1);
        END;

        COMMIT TRANSACTION;
        PRINT 'Sales order detail for SalesOrderID ' + CAST(@SalesOrderID AS NVARCHAR(10)) + ', ProductID ' + CAST(@ProductID AS NVARCHAR(10)) + ' deleted successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
        PRINT 'Failed to delete sales order detail. Please try again.';
        RETURN -1;
    END CATCH;

    RETURN 0;
END;
GO
