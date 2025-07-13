--level task c
--task 20
use level_task_C;

CREATE TABLE TableA (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO TableA (id, name, salary)
VALUES
    (1, 'John Doe', 50000.00),
    (2, 'Jane Smith', 60000.00),
    (3, 'Michael Johnson', 55000.00);


-- Example: Creating TableB
CREATE TABLE TableB (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
    -- Add other columns as needed
);


INSERT INTO TableB (id, name, salary)
SELECT id, name, salary
FROM TableA;


SELECT * FROM TableA;
SELECT * FROM TableB;