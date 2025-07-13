CREATE PROCEDURE sp_SCD_Type1_Customer
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO DimCustomer AS Target
    USING Staging_Customer AS Source
    ON (Target.CustomerID = Source.CustomerID)
    WHEN NOT MATCHED BY Target THEN
        -- Insert new records
        INSERT (CustomerID, CustomerName, EmailAddress)
        VALUES (Source.CustomerID, Source.CustomerName, Source.EmailAddress)
    WHEN MATCHED AND (Target.CustomerName <> Source.CustomerName OR Target.EmailAddress <> Source.EmailAddress) THEN
        -- Update existing records if any relevant attribute has changed.
        -- All attributes in this scenario are Type 1, so they are overwritten.
        UPDATE SET
            Target.CustomerName = Source.CustomerName,
            Target.EmailAddress = Source.EmailAddress;
END;
