-- level task c 
-- task 6

USE level_task_C;
GO

-- Create the stored procedure
CREATE PROCEDURE CalculateManhattanDistance
    @id1 INT,    -- ID of Point 1
    @id2 INT     -- ID of Point 2
AS
BEGIN
    DECLARE @a FLOAT, @b FLOAT, @c FLOAT, @d FLOAT;
    DECLARE @distance FLOAT;

    -- Fetch the coordinates of Point 1
    SELECT @a = Lat_n, @b = Long_w
    FROM station
    WHERE id = @id1;

    -- Fetch the coordinates of Point 2
    SELECT @c = Lat_n, @d = Long_w
    FROM station
    WHERE id = @id2;

    -- Calculate the Manhattan Distance and round it to 2 decimal places
    SET @distance = ROUND(ABS(@a - @c) + ABS(@b - @d), 2);

    -- Return the distance
    SELECT @distance AS Manhattan_Distance;
END;
GO

-- Example usage of the stored procedure
DECLARE @id1 INT, @id2 INT;

-- Assuming these values are the IDs of the points
SET @id1 = 1; -- ID of Point 1
SET @id2 = 2; -- ID of Point 2

-- Call the stored procedure
EXEC CalculateManhattanDistance @id1, @id2;