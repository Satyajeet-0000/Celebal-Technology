CREATE PROCEDURE sp_SCD_Type3_Customer
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO DimCustomer AS Target
    USING Staging_Customer AS Source
    ON (Target.CustomerID = Source.CustomerID)
    WHEN NOT MATCHED BY Target THEN
        -- Insert new records, PreviousRegion is NULL initially
        INSERT (CustomerID, CustomerName, CurrentRegion, PreviousRegion)
        VALUES (Source.CustomerID, Source.CustomerName, Source.Region, NULL)
    WHEN MATCHED THEN
        -- Update existing records.
        -- Use CASE statements to conditionally update PreviousRegion and CurrentRegion
        -- and also update other Type 1 attributes like CustomerName.
        UPDATE SET
            Target.PreviousRegion = CASE
                                        WHEN Target.CurrentRegion <> Source.Region THEN Target.CurrentRegion
                                        ELSE Target.PreviousRegion -- Keep existing previous if region didn't change
                                    END,
            Target.CurrentRegion = Source.Region, -- Always update CurrentRegion to the latest from source
            Target.CustomerName = Source.CustomerName; -- Update other Type 1 attributes
END;