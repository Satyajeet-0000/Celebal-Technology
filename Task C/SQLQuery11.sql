--level c task
-- task 11



use level_task_C;
SELECT s.name AS student_name
FROM students s
JOIN friends f ON s.id = f.id
JOIN packages p_self ON s.id = p_self.id
JOIN packages p_friend ON f.friend_id = p_friend.id
WHERE p_friend.salary > p_self.salary
ORDER BY p_friend.salary;