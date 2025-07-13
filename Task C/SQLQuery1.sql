use level_task_C;


WITH TaskGroups AS (
    SELECT
        task_id,
        start_date,
        end_date,
        ROW_NUMBER() OVER (ORDER BY start_date) AS rn_start,
        ROW_NUMBER() OVER (ORDER BY end_date) AS rn_end
    FROM
        project
),
Projects AS (
    SELECT
        task_id,
        MIN(start_date) AS start_date,
        MAX(end_date) AS end_date,
        DATEDIFF(DAY, MIN(start_date), MAX(end_date)) + 1 AS duration
    FROM (
        SELECT
            task_id,
            start_date,
            end_date,
            rn_start - rn_end AS grp
        FROM
            TaskGroups
    ) AS grouped
    GROUP BY
        task_id, grp
)
SELECT
    start_date,
    end_date
FROM
    Projects
ORDER BY
    duration ASC,
    start_date ASC;