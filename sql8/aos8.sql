WITH RECURSIVE recursive_cte AS (
    -- Base case: Select rows where the foreign key is NULL
    SELECT staff_id, staff_name, 1 AS level
    FROM staff
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: Join the table to itself
    SELECT t.staff_id, t.staff_name, level + 1
    FROM staff t
    JOIN recursive_cte r ON t.manager_id = r.staff_id
)
SELECT * FROM recursive_cte order by level desc;
