
-- LEVEL TASK C
-- task 4
use level_task_C;

SELECT c.contest_id,
       c.hacker_id,
       c.name,
       COALESCE(SUM(ss.total_submissions), 0) AS total_submissions,
       COALESCE(SUM(ss.total_accepted_submissions), 0) AS total_accepted_submissions,
       COALESCE(SUM(vs.total_views), 0) AS total_views,
       COALESCE(SUM(vs.total_unique_views), 0) AS total_unique_views
FROM contests c
LEFT JOIN colleges col ON c.contest_id = col.contest_id
LEFT JOIN challenges ch ON col.college_id = ch.college_id
LEFT JOIN submission_stats ss ON ch.challeges_id = ss.challenge_id
LEFT JOIN view_stats vs ON ch.challeges_id = vs.challenges_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING SUM(COALESCE(ss.total_submissions, 0)) + SUM(COALESCE(ss.total_accepted_submissions, 0))
       + SUM(COALESCE(vs.total_views, 0)) + SUM(COALESCE(vs.total_unique_views, 0)) > 0
ORDER BY c.contest_id;