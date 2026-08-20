-- ruleset_access (see V43__ruleset_access_grants.sql) is now the sole source of truth for ruleset access
-- resolution. All application code (RulesetRepository, upsert_ruleset()) has been migrated off owner_id;
-- this drops the now-unused column and its FK.
ALTER TABLE ruleset DROP CONSTRAINT fk_ruleset_owner_id;
ALTER TABLE ruleset DROP COLUMN owner_id;
