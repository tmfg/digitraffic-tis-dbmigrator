CREATE MATERIALIZED VIEW statistics
    AS SELECT format AS name, status AS subserie, COUNT(status) as count,
              date_trunc('day', entry.created) as record_created_at,
              'unit' AS unit,
              'entry-statuses' AS series
       FROM entry
       WHERE entry.created >= now() - interval '30 days'
       GROUP BY format, status, date_trunc('day', entry.created)
       UNION
       SELECT name, status AS subserie, COUNT(name) as count,
              date_trunc('day', task.created) as record_created_at,
              'unit' AS unit,
              'task-statuses' AS series
       FROM task
       WHERE task.created >= now() - interval '30 days'
       GROUP BY name, status, date_trunc('day', task.created);


