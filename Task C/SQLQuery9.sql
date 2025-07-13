
--level task c 
-- task 9


use level_task_C;

WITH NodeTypes AS (
    -- Find the root node
    SELECT 
        t1.N AS value,
        'ROOT' AS node_type
    FROM 
        BST t1
    LEFT JOIN 
        BST t2 ON t1.N = t2.P
    WHERE 
        t1.P IS NULL

    UNION ALL

    -- Find the leaf nodes
    SELECT 
        N AS value,
        'LEAF' AS node_type
    FROM 
        BST
    WHERE 
        N NOT IN (SELECT P FROM BST WHERE P IS NOT NULL)

    UNION ALL

    -- Find the inner nodes
    SELECT 
        N AS value,
        'INNER' AS node_type
    FROM 
        BST
    WHERE 
        N IN (SELECT P FROM BST WHERE P IS NOT NULL)
        AND N NOT IN (
            SELECT 
                t1.N
            FROM 
                BST t1
            LEFT JOIN 
                BST t2 ON t1.N = t2.P
            WHERE 
                t1.P IS NULL
        )
)
SELECT * FROM NodeTypes WHERE value = 5;  -- Replace 5 with your target value