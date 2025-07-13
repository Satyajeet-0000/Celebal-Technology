-- level task c 
-- task 8


-- Generate a row number for each occupation to handle the pivot
WITH NumberedOccupations AS (
    SELECT 
        name, 
        occupation,
        ROW_NUMBER() OVER (PARTITION BY occupation ORDER BY name) AS row_num
    FROM occupation
)

-- Pivot the table
SELECT 
    MAX(CASE WHEN occupation = 'doctor' THEN name END) AS doctor,
    MAX(CASE WHEN occupation = 'professor' THEN name END) AS professor,
    MAX(CASE WHEN occupation = 'singer' THEN name END) AS singer,
    MAX(CASE WHEN occupation = 'actor' THEN name END) AS actor
FROM 
    NumberedOccupations
GROUP BY 
    row_num
ORDER BY 
    row_num;