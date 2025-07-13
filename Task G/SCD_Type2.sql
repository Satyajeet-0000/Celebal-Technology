CREATE PROCEDURE sp_SCD_Type2_Customer
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentDate DATE = GETDATE();

    -- Step 1: Update existing records that have changed
    UPDATE Target
    SET
        Target.EndDate = DATEADD(day, -1, @CurrentDate), -- Set end date to yesterday
        Target.IsCurrent = 0                             -- Mark as not current
    FROM
        DimCustomer AS Target
    INNER JOIN
        Staging_Customer AS Source
    ON
        Target.CustomerID = Source.CustomerID
    WHERE
        Target.IsCurrent = 1 AND Target.Address <> Source.Address; -- Only update if address has changed

    -- Step 2: Insert new or changed records
    INSERT INTO DimCustomer (CustomerID, CustomerName, Address, StartDate, EndDate, IsCurrent)
    SELECT
        Source.CustomerID,
        Source.CustomerName,
        Source.Address,
        @CurrentDate AS StartDate,
        '9999-12-31' AS EndDate, -- Far future date for current record
        1 AS IsCurrent
    FROM
        Staging_Customer AS Source
    LEFT JOIN
        DimCustomer AS Target
    ON
        Source.CustomerID = Target.CustomerID AND Target.IsCurrent = 1
    WHERE
        Target.CustomerSK IS NULL -- New customer
        OR (Target.CustomerSK IS NOT NULL AND Target.Address <> Source.Address); -- Existing customer with changed address
END;