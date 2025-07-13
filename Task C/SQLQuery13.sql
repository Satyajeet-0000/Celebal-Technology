--level task c
-- task 13 

use level_task_C;

WITH MonthlyRatios AS (
    SELECT
        bu_id,
        month,
        year,
        SUM(cost) AS total_cost,
        SUM(revenue) AS total_revenue,
        CASE 
            WHEN SUM(revenue) != 0 THEN (SUM(cost) / SUM(revenue)) 
            ELSE NULL 
        END AS cost_revenue_ratio
    FROM
        bu_finances
    GROUP BY
        bu_id, year, month
)
SELECT
    bu_id,
    CONCAT(year, '-', RIGHT('00' + CAST(month AS VARCHAR(2)), 2)) AS year_month,
    total_cost,
    total_revenue,
    cost_revenue_ratio
FROM
    MonthlyRatios
ORDER BY
    bu_id, year, month;