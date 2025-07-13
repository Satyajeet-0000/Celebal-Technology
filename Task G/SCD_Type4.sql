CREATE PROCEDURE sp_SCD_Type4_Product
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentDate DATE = GETDATE();

    -- Step 1: Update the main dimension table (SCD Type 1 for current state)
    MERGE INTO DimProduct AS Target
    USING Staging_Product AS Source
    ON (Target.ProductID = Source.ProductID)
    WHEN NOT MATCHED BY Target THEN
        -- Insert new products into the main dimension
        INSERT (ProductID, ProductName, CurrentPrice)
        VALUES (Source.ProductID, Source.ProductName, Source.Price)
    WHEN MATCHED AND (Target.ProductName <> Source.ProductName OR Target.CurrentPrice <> Source.Price) THEN
        -- Update existing products in the main dimension
        UPDATE SET
            Target.ProductName = Source.ProductName,
            Target.CurrentPrice = Source.Price;

    -- Step 2: Insert/Update the history table (SCD Type 2 logic for history)
    -- First, close out old history records if price has changed
    UPDATE ph
    SET ph.EndDate = DATEADD(day, -1, @CurrentDate)
    FROM DimProduct_History ph
    INNER JOIN DimProduct dp ON ph.ProductID = dp.ProductID
    INNER JOIN Staging_Product sp ON dp.ProductID = sp.ProductID
    WHERE ph.EndDate = '9999-12-31' -- Only update current history record
      AND dp.CurrentPrice <> sp.Price; -- Only if price has actually changed in the main dimension

    -- Then, insert new history records for changed prices or new products
    INSERT INTO DimProduct_History (ProductID, Price, StartDate, EndDate)
    SELECT
        sp.ProductID,
        sp.Price,
        @CurrentDate AS StartDate,
        '9999-12-31' AS EndDate
    FROM Staging_Product sp
    LEFT JOIN DimProduct_History ph ON sp.ProductID = ph.ProductID AND ph.EndDate = '9999-12-31'
    WHERE ph.ProductHistorySK IS NULL -- New product, no history yet
       OR (ph.ProductHistorySK IS NOT NULL AND ph.Price <> sp.Price); -- Existing product with new price
END;