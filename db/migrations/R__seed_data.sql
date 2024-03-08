-- # Seed Data

-- ## Main parent company
--
-- Fintraffic is the main company of TIS VACO and forms as basis and parent for all company and relationship data.
INSERT INTO company (business_id, name)
     VALUES ('2942108-7', 'Fintraffic Oy')
ON CONFLICT (business_id)
         DO UPDATE SET name = 'Fintraffic Oy';

-- ## `upsert_ruleset`
--
-- Helper function and related logic for upserting external ruleset metadata.

-- !! clean up old versions of the function
DROP FUNCTION IF EXISTS upsert_ruleset(_business_id TEXT, _transit_data_format transit_data_format, _identifying_name TEXT, _description TEXT, _type TEXT, _category ruleset_category);

-- !! This is the latest version of this function, should've created original as empty no-op function and have its
-- !! definition always here. Sorry on my behalf for future maintainers.
CREATE OR REPLACE FUNCTION upsert_ruleset(
    _business_id TEXT,
    _transit_data_format transit_data_format,
    _identifying_name TEXT,
    _description TEXT,
    _type TEXT,
    _category ruleset_category,
    _deps TEXT[])
    RETURNS SETOF ruleset
    LANGUAGE plpgsql
AS
$$
DECLARE
BEGIN
    RETURN QUERY
        INSERT INTO ruleset (owner_id, category, identifying_name, description, type, format, dependencies)
            VALUES ((SELECT id FROM company WHERE business_id = _business_id),
                    _category,
                    _identifying_name,
                    _description,
                    _type,
                    _transit_data_format,
                    _deps)
            ON CONFLICT (identifying_name)
                DO UPDATE SET category = _category,
                    owner_id = (SELECT id FROM company WHERE business_id = _business_id),
                    description = _description,
                    type = _type,
                    format = _transit_data_format,
                    dependencies = _deps
            RETURNING *;
END
$$;

-- NOTE: If migrating to new replacement rules, keep old ones and set them as SPECIFIC instead of simply deleting the row!
SELECT upsert_ruleset('2942108-7', 'gtfs', 'gtfs.canonical.v4_0_0', 'Legacy Canonical GTFS Validator by MobilityData (v4.0.0)', 'validation_syntax', 'specific', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'gtfs', 'gtfs.canonical.v4_1_0', 'Legacy Canonical GTFS Validator by MobilityData (v4.1.0)', 'validation_syntax', 'specific', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'netex', 'netex.entur.v1_0_1', 'Legacy NeTEx Validator by Entur, version v1.0.1', 'validation_syntax', 'specific', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'netex', 'netex2gtfs.entur.v2_0_6', 'Legacy NeTEx to GTFS Converter by Entur, version v2.0.6', 'validation_syntax', 'specific', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'gtfs', 'gtfs2netex.fintraffic.v1_0_0', 'Legacy GTFS to NeTEx Converter by Fintraffic, version v1.12.0', 'validation_syntax', 'specific', ARRAY ['prepare.download', 'validate']);
-- currently available latest&greatest rulesets
SELECT upsert_ruleset('2942108-7', 'gtfs', 'gtfs.canonical', 'Canonical GTFS Validator by MobilityData', 'validation_syntax', 'generic', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'netex', 'netex.entur', 'NeTEx Validator by Entur', 'validation_syntax', 'generic', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'netex', 'netex2gtfs.entur', 'NeTEx to GTFS Converter by Entur', 'conversion_syntax', 'generic', ARRAY ['prepare.download', 'prepare.stopsAndQuays', 'netex.entur', 'convert']);
SELECT upsert_ruleset('2942108-7', 'gtfs', 'gtfs2netex.fintraffic', 'GTFS to NeTEx Converter by Fintraffic', 'conversion_syntax', 'generic', ARRAY ['prepare.download', 'gtfs.canonical', 'convert']);

-- ## `upsert_overrides`
--
-- Helper function and related logic for upserting ruleset notice overrides, mainly for controlling which rules should
-- e.g. cause cancellation of further tasks and how they should be reported as.

DROP TYPE IF EXISTS rule_severity CASCADE;
CREATE TYPE rule_severity AS
(
    rule_name TEXT,
    severity  TEXT
);

CREATE OR REPLACE FUNCTION upsert_overrides(
    _ruleset_id BIGINT,
    _overrides rule_severity[]
) RETURNS SETOF rule_severity_override
    LANGUAGE sql
AS
$$
    -- before we insert/update new ones, cleanup old data first
DELETE
  FROM rule_severity_override
 WHERE ruleset_id = _ruleset_id;
    -- then upsert the new rows
   INSERT INTO rule_severity_override (ruleset_id, name, severity)
   SELECT _ruleset_id, o.*
     FROM UNNEST(_overrides) AS o(rule_name, severity)
       ON CONFLICT (ruleset_id, name) DO UPDATE SET severity = excluded.severity
RETURNING *;
$$;

SELECT upsert_overrides((SELECT id FROM ruleset WHERE identifying_name = 'gtfs.canonical'),
                        ARRAY [('invalid_url', 'WARNING')]::rule_severity[]);

-- ## `upsert_feature_flags`
--
-- Supported feature flags injection. We only want to support a specific set of feature flags as determined in the list
-- below. In some other services feature flags are provided as a set of strings, we do a bit more tracking than that.
DROP TYPE IF EXISTS feature_flag_names CASCADE;
CREATE TYPE feature_flag_names AS
(
    flag_name TEXT,
    modified_by TEXT
);

CREATE OR REPLACE FUNCTION upsert_feature_flags(
    _feature_flags feature_flag_names[]
) RETURNS SETOF feature_flag
    LANGUAGE sql
AS
$$
    -- then upsert the new rows
   INSERT INTO feature_flag (name, modified_by)
   SELECT o.flag_name, o.modified_by
     FROM UNNEST(_feature_flags) AS o(flag_name, modified_by)
RETURNING *;
$$;

SELECT upsert_feature_flags(ARRAY [('emails.entryCompleteEmail', 'system'), ('emails.feedStatusEmail', 'system')]::feature_flag_names[]);
