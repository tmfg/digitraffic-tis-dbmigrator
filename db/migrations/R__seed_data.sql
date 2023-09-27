INSERT INTO organization (business_id, name)
     VALUES ('2942108-7', 'Fintraffic Oy')
ON CONFLICT (business_id)
         DO UPDATE SET name = 'Fintraffic Oy';

SELECT upsert_ruleset('2942108-7', 'gtfs.canonical.v4_0_0', 'Canonical GTFS Validator by MobilityData, version v4.1.0', 'validation_syntax');
SELECT upsert_ruleset('2942108-7', 'gtfs.canonical.v4_1_0', 'Canonical GTFS Validator by MobilityData, version v4.1.0', 'validation_syntax');
SELECT upsert_ruleset('2942108-7', 'netex.entur.v1_0_1', 'NeTEx Validator by Entur, version v1.0.1', 'validation_syntax');
