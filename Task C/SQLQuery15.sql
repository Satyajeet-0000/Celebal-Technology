--level task c
--task 15 

use level_task_C;

SELECT employee_id, employee_name, salary
FROM (
    SELECT 
        employee_id,
        employee_name,
        salary,
        ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
    FROM employees15
) ranked_employees
WHERE salary_rank <= 5;