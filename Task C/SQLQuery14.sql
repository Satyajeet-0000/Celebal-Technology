--level task c
-- task 14

use level_task_C;

SELECT 
    sub_band,
    COUNT(*) AS headcount,
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS percentage_of_headcount
FROM 
    employees
GROUP BY 
    sub_band
ORDER BY 
    sub_band;