-- Link Packages to Tasks instead of Entries as Tasks are what create them, not entries themselves. This allows for
-- better reuse of package names as those won't be tied to predefined prefixes anymore.

-- 1) add the new column
ALTER TABLE package ADD COLUMN task_id BIGINT;
-- 2) fill it with guessed data
CREATE FUNCTION v6_migration_quess_task_id(_entry_id BIGINT) RETURNS int LANGUAGE SQL AS
$$ SELECT id FROM task t WHERE t.entry_id = _entry_id LIMIT 1; $$;

UPDATE package p SET task_id = v6_migration_quess_task_id(p.entry_id);
-- 3) remove temporary worked function
DROP FUNCTION v6_migration_quess_task_id(_entry_id BIGINT);
-- 4) make the new column required
ALTER TABLE package
    ALTER COLUMN task_id SET NOT NULL,
    ADD CONSTRAINT fk_package_task_task_id FOREIGN KEY (task_id) REFERENCES task (id) ON DELETE CASCADE;
-- 5) remove the original column
ALTER TABLE package DROP COLUMN entry_id;
