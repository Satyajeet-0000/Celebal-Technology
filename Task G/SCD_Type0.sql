CREATE PROCEDURE sp_SCD_Type0_Customer
AS
BEGIN
    SET NOCOUNT ON;

    -- Merge data from Staging to DimCustomer
    MERGE INTO DimCustomer AS Target
    USING Staging_Customer AS Source
    ON (Target.CustomerID = Source.CustomerID)
    WHEN NOT MATCHED BY Target THEN
        -- Insert new records. DateOfBirth is loaded once and never updated.
        INSERT (CustomerID, CustomerName, DateOfBirth)
        VALUES (Source.CustomerID, Source.CustomerName, Source.DateOfBirth)
    WHEN MATCHED THEN
        -- Update only attributes that are NOT Type 0.
        -- For Type 0, we explicitly DO NOT update DateOfBirth.
        UPDATE SET
            Target.CustomerName = Source.CustomerName; -- Other attributes can be updated if not Type 0
END;