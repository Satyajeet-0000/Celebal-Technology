-- level task c
-- task 5


USE level_task_C;

WITH submissions_count AS (
    SELECT
        submission_date,
        hacker_id,
        COUNT(*) AS num_submissions
    FROM submissions2  -- Corrected table name
    GROUP BY submission_date, hacker_id
),

max_submissions_per_day AS (
    SELECT
        submission_date,
        MAX(num_submissions) AS max_submissions
    FROM submissions_count
    GROUP BY submission_date
)

SELECT
    s.submission_date,
    COUNT(DISTINCT s.hacker_id) AS num_unique_hackers,
    --MIN(h.hacker_id) AS hacker_with_max_submissions,
    MIN(h.name) AS hacker_name
FROM max_submissions_per_day m
JOIN submissions_count s ON m.submission_date = s.submission_date
JOIN hackers h ON s.hacker_id = h.hacker_id
WHERE s.num_submissions = m.max_submissions
GROUP BY s.submission_date
ORDER BY s.submission_date;