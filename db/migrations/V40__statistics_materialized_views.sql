CREATE MATERIALIZED VIEW status_statistics
    AS SELECT format AS name, status AS subserie, COUNT(status) as count,
              date_trunc('day', entry.created) as record_created_at,
              'pieces' AS unit,
              'entry-statuses' AS series
       FROM entry
       GROUP BY format, status, date_trunc('day', entry.created)
       UNION
       SELECT name, status AS subserie, COUNT(name) as count,
              date_trunc('day', task.created) as record_created_at,
              'pieces' AS unit,
              'task-statuses' AS series
       FROM task
       GROUP BY name, status, date_trunc('day', task.created);


