-- Allowing post deps means there might be multiple tasks with same name (=ruleset) in one run, so tasks need to be
-- identified uniquely. Tasks already have a database id, but since tasks are visible to outside world, they need public
-- id as well.
ALTER TABLE task
    ADD COLUMN public_id TEXT UNIQUE NOT NULL DEFAULT nanoid();
-- modify ruleset table to have separate before and after dependencies instead of just 'dependencies' which effectively
-- are before dependencies
ALTER TABLE ruleset
    RENAME COLUMN dependencies TO before_dependencies;
ALTER TABLE ruleset
    ADD COLUMN IF NOT EXISTS after_dependencies TEXT[] DEFAULT array[]::text[];
