INSERT INTO company (business_id, name)
     VALUES ('2942108-7', 'Fintraffic Oy')
ON CONFLICT (business_id)
         DO UPDATE SET name = 'Fintraffic Oy';

-- clean up old versions of the function
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


SELECT upsert_ruleset('2942108-7', 'gtfs', 'gtfs.canonical.v4_0_0', 'Canonical GTFS Validator by MobilityData, version v4.0.0', 'validation_syntax', 'specific', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'gtfs', 'gtfs.canonical.v4_1_0', 'Canonical GTFS Validator by MobilityData, version v4.1.0', 'validation_syntax', 'generic', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'netex', 'netex.entur.v1_0_1', 'NeTEx Validator by Entur, version v1.0.1', 'validation_syntax', 'generic', ARRAY ['prepare.download', 'validate']);
SELECT upsert_ruleset('2942108-7', 'netex', 'netex2gtfs.entur.v2_0_6', 'NeTEx to GTFS Converter by Entur, version v2.0.6', 'conversion_syntax', 'generic', ARRAY ['prepare.download', 'prepare.stopsAndQuays', 'netex.entur.v1_0_1', 'convert']);

DROP TYPE IF EXISTS rule_severity;
CREATE TYPE rule_severity AS
(
    rule_name TEXT,
    severity  TEXT
);

CREATE OR REPLACE FUNCTION upsert_overrides(
    _ruleset_id BIGINT,
    _overrides rule_severity[]
) RETURNS VOID
    LANGUAGE sql
AS
$$

DELETE
FROM rule_severity_override
WHERE ruleset_id = _ruleset_id;
    -- then upsert the new rows
INSERT INTO rule_severity_override (ruleset_id, name, severity)
SELECT _ruleset_id, o.*
FROM UNNEST(_overrides) AS o(rule_name, severity)
ON CONFLICT (ruleset_id, name) DO UPDATE SET severity = excluded.severity;
$$;

SELECT upsert_overrides((SELECT id FROM ruleset WHERE identifying_name = 'gtfs.canonical.v4_1_0'),
                        ARRAY []::rule_severity[]);

SELECT upsert_ruleset('2942108-7', 'gtfs', 'gtfs2netex.fintraffic.v1_0_0', 'GTFS to NeTEx Converter by Fintraffic, version v1.12.0', 'conversion_syntax', 'generic', ARRAY ['prepare.download', 'gtfs.canonical.v4_1_0', 'convert']);

