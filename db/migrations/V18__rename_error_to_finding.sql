-- 'error' is renamed to 'finding' as that matches better what the data contains; actual severity level is a field
ALTER TABLE error RENAME TO finding;
ALTER INDEX idx_error_entry_id RENAME TO idx_finding_entry_id;
ALTER INDEX idx_error_task_id RENAME TO idx_finding_task_id;
ALTER TABLE finding RENAME CONSTRAINT fk_error_entry_entry_id TO fk_finding_entry_entry_id;
ALTER TABLE finding RENAME CONSTRAINT fk_error_task_task_id TO fk_finding_task_task_id;
ALTER TABLE finding RENAME CONSTRAINT fk_error_ruleset_id TO fk_finding_ruleset_id;


