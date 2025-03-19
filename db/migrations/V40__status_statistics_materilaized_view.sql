CREATE MATERIALIZED VIEW status_statistics
    AS SELECT status, COUNT(status) as count,
    CURRENT_TIMESTAMP AS view_created_at,
    'entries' AS unit
    FROM entry
    GROUP BY  status
