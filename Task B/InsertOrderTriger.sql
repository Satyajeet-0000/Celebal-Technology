USE AdventureWorks2019; -- Ensure you are in the correct AdventureWorks database
GO

IF OBJECT_ID('trg_InsteadOfDeleteSalesOrderHeader', 'TR') IS NOT NULL
    DROP TRIGGER trg_InsteadOfDeleteSalesOrderHeader;
GO

-- This trigger is adapted for AdventureWorks to handle deleting SalesOrderHeader
-- and related SalesOrderDetail records due to referential integrity.
CREATE TRIGGER trg_InsteadOfDeleteSalesOrderHeader
ON Sales.SalesOrderHeader -- Changed from 'Orders' to 'Sales.SalesOrderHeader'
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- Ensures transaction rolls back on error

    BEGIN TRY
        BEGIN TRANSACTION;

        -- First, delete corresponding records from Sales.SalesOrderDetail
        DELETE sod
        FROM Sales.SalesOrderDetail AS sod
        JOIN DELETED AS d ON sod.SalesOrderID = d.SalesOrderID; -- Changed OrderID to SalesOrderID

        -- Then, delete the SalesOrderHeader from the Sales.SalesOrderHeader table
        DELETE soh
        FROM Sales.SalesOrderHeader AS soh
        JOIN DELETED AS d ON soh.SalesOrderID = d.SalesOrderID; -- Changed OrderID to SalesOrderID

        COMMIT TRANSACTION;
        PRINT 'Sales Order and its details deleted successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
        PRINT 'Failed to delete Sales Order. Please try again.';
        RAISERROR('Deletion failed.', 16, 1); -- Re-raise error to calling context
    END CATCH;
END;
GO