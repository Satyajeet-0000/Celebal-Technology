-- level tack c
-- task 10

use level_task_C;

SELECT 
    c.company_code,
    c.founder AS founder_name,
    COUNT(DISTINCT lm.lead_manager_code) AS total_number_of_lead_managers,
    COUNT(DISTINCT sm.senior_manager_code) AS total_number_of_senior_managers,
    COUNT(DISTINCT e.employee_code) AS total_number_of_employees
FROM 
    company c
LEFT JOIN 
    lead_manager lm ON c.company_code = lm.company_code
LEFT JOIN 
    senoir_manager sm ON c.company_code = sm.company_code
LEFT JOIN 
    manager m ON c.company_code = m.company_code
LEFT JOIN 
    employee e ON c.company_code = e.company_code
GROUP BY 
    c.company_code, c.founder
ORDER BY 
    c.company_code ASC;