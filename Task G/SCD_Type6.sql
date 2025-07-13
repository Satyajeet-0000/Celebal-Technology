-- Assume Dimension Table: DimCustomer (
--     CustomerSK INT PK IDENTITY,
--     CustomerID INT,
--     CustomerName VARCHAR(100),         -- Type 1: Always current
--     Address VARCHAR(255),               -- Type 2: Historical record
--     CurrentRegion VARCHAR(50),          -- Type 6 (Type 3 part): Current region
--     PreviousRegion VARCHAR(50),         -- Type 6 (Type 3 part): Previous region
--     StartDate DATE,                     -- Type 2: Start date of this record
--     EndDate DATE,                       -- Type 2: End date of this record
--     IsCurrent BIT                       -- Type 2: Flag for current record
-- )
-- Assume Source Table: Staging_Customer (CustomerID INT, CustomerName VARCHAR(100), Address VARCHAR(255), Region VARCHAR(50))

CREATE PROCEDURE sp_SCD_Type6_Customer
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentDate DATE = GETDATE();

    -- Step 1: Update existing records where Type 2 attributes (e.g., Address) have changed
    -- or if Type 3 attribute (Region) has changed, we need to close the old Type 2 record.
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
        Target.IsCurrent = 1
        AND (Target.Address <> Source.Address OR Target.CurrentRegion <> Source.Region); -- Close if Address or Region changed

    -- Step 2: Insert new records or new versions of existing records
    INSERT INTO DimCustomer (CustomerID, CustomerName, Address, CurrentRegion, PreviousRegion, StartDate, EndDate, IsCurrent)
    SELECT
        Source.CustomerID,
        Source.CustomerName,
        Source.Address,
        Source.Region AS CurrentRegion,
        CASE
            WHEN Target.CustomerSK IS NOT NULL AND Source.Region <> Target.CurrentRegion THEN Target.CurrentRegion
            ELSE NULL
        END AS PreviousRegion, -- Set PreviousRegion if Region changed
        @CurrentDate AS StartDate,
        '9999-12-31' AS EndDate,
        1 AS IsCurrent
    FROM
        Staging_Customer AS Source
    LEFT JOIN
        DimCustomer AS Target
    ON
        Source.CustomerID = Target.CustomerID AND Target.IsCurrent = 1
    WHERE
        Target.CustomerSK IS NULL -- New customer
        OR (Target.CustomerSK IS NOT NULL AND (Target.Address <> Source.Address OR Target.CurrentRegion <> Source.Region)); -- Existing customer with changed Address or Region

    -- Step 3: Update Type 1 attributes (e.g., CustomerName) for current records
    -- This handles cases where only Type 1 attributes change, or for new records inserted in Step 2.
    UPDATE Target
    SET
        Target.CustomerName = Source.CustomerName
    FROM
        DimCustomer AS Target
    INNER JOIN
        Staging_Customer AS Source
    ON
        Target.CustomerID = Source.CustomerID
    WHERE
        Target.IsCurrent = 1 AND Target.CustomerName <> Source.CustomerName;
END;
