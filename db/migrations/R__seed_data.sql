INSERT INTO organization (business_id, name)
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
            VALUES ((SELECT id FROM organization WHERE business_id = _business_id),
                    _category,
                    _identifying_name,
                    _description,
                    _type,
                    _transit_data_format,
                    _deps)
            ON CONFLICT (identifying_name)
                DO UPDATE SET category = _category,
                    owner_id = (SELECT id FROM organization WHERE business_id = _business_id),
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
