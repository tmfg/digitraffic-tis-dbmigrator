-- allow ruleset_id to be NULL so that internal tasks can also report findings, e.g. exceptions being thrown
ALTER TABLE finding
    ALTER COLUMN ruleset_id DROP NOT NULL;
