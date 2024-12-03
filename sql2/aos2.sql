CREATE OR REPLACE FUNCTION process_value_aos2(p_value INTEGER)
RETURNS TEXT AS $$
BEGIN
    RETURN CASE
        WHEN p_value BETWEEN 97 AND 122 THEN CHR(p_value)
        WHEN p_value BETWEEN 65 AND 90 THEN CHR(p_value)
        WHEN p_value BETWEEN 32 AND 34 THEN CHR(p_value)
        WHEN p_value BETWEEN 39 AND 41 THEN CHR(p_value)
        WHEN p_value BETWEEN 44 AND 46 THEN CHR(p_value)
        WHEN p_value BETWEEN 58 AND 59 THEN CHR(p_value)
        WHEN p_value BETWEEN 63 AND 63 THEN CHR(p_value)
        ELSE ''
    END;
END;
$$
 LANGUAGE plpgsql;

WITH intermediate_a AS (
    SELECT id AS id,
           process_value_aos2(value) AS value
    FROM letters_a
),
intermediate_b AS (
    SELECT id AS id,
           process_value_aos2(value) AS value
    FROM letters_b
),
output_a AS (
    SELECT ARRAY_TO_STRING(ARRAY_AGG(la.value ORDER BY la.id), '') AS sentence
    FROM intermediate_a la
),
output_b AS (
    SELECT ARRAY_TO_STRING(ARRAY_AGG(lb.value ORDER BY lb.id), '') AS sentence
    FROM intermediate_b lb
)
SELECT (SELECT sentence FROM output_a) || '' || (SELECT sentence FROM output_b) AS combined_sentence;
