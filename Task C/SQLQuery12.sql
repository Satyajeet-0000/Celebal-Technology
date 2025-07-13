-- level task c
-- task 12

use level_task_C;

WITH TotalCosts AS (
    SELECT
        job_family,
        SUM(CASE WHEN region = 'India' THEN cost ELSE 0 END) AS india_cost,
        SUM(CASE WHEN region = 'International' THEN cost ELSE 0 END) AS international_cost,
        SUM(cost) AS total_cost
    FROM
        job_family_costs
    GROUP BY
        job_family
),
PercentageCosts AS (
    SELECT
        job_family,
        india_cost,
        international_cost,
        total_cost,
        (india_cost / total_cost) * 100 AS india_percentage,
        (international_cost / total_cost) * 100 AS international_percentage
    FROM
        TotalCosts
)
SELECT
    job_family,
    india_percentage,
    international_percentage
FROM
    PercentageCosts
ORDER BY
    job_family;