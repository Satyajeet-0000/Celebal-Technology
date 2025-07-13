
use level_task_C

SELECT p1.X AS X1, p1.Y AS Y1, p2.X AS X2, p2.Y AS Y2
FROM functions p1, functions p2
WHERE p1.X = p2.Y
  AND p1.Y = p2.X
  AND p1.X < p2.X
ORDER BY X1 ASC;