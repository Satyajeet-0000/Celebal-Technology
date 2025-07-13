-- level task c
-- task 19

use level_task_C;

WITH Salaries AS (
    -- Calculate the actual average salary
    SELECT AVG(salary) AS ActualAverageSalary
    FROM employees15
),
MiscalculatedSalaries AS (
    -- Calculate the miscalculated average salary (excluding salaries with zeros)
    SELECT AVG(salary) AS MiscalculatedAverageSalary
    FROM employees15
    WHERE salary <> 0
)
-- Calculate the difference and round up
SELECT CEILING(Salaries.ActualAverageSalary - MiscalculatedSalaries.MiscalculatedAverageSalary) AS ErrorAmount
FROM Salaries
CROSS JOIN MiscalculatedSalaries;