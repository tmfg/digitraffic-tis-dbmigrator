INSERT INTO organization (business_id, name)
     VALUES ('2942108-7', 'Fintraffic Oy')
ON CONFLICT (business_id)
         DO UPDATE SET name = 'Fintraffic Oy';

INSERT INTO ruleset (owner_id, category, identifying_name, description, type)
     VALUES ((SELECT id FROM organization WHERE business_id = '2942108-7'),
             'generic',
             'gtfs.canonical.v4_0_0',
             'Canonical GTFS Validator by MobilityData, version v4.0.0',
             'validation_syntax')
ON CONFLICT (identifying_name)
         DO UPDATE SET category = 'generic',
                       owner_id = (SELECT id FROM organization WHERE business_id = '2942108-7'),
                       description = 'Canonical GTFS Validator by MobilityData, version v4.0.0',
                       type = 'validation_syntax';

SELECT upsert_ruleset('2942108-7', 'gtfs.canonical.v4_1_0', 'Canonical GTFS Validator by MobilityData, version v4.1.0', 'validation_syntax');

INSERT INTO ruleset (owner_id, category, identifying_name, description, type)
     VALUES ((SELECT id FROM organization WHERE business_id = '2942108-7'),
             'generic',
             'netex.entur.v1_0_1',
             'NeTEx Validator by Entur, version v1.0.1',
             'validation_syntax')
ON CONFLICT (identifying_name)
         DO UPDATE SET category = 'generic',
                       owner_id = (SELECT id FROM organization WHERE business_id = '2942108-7'),
                       description = 'NeTEx Validator by Entur, version v1.0.1',
                       type = 'validation_syntax';
