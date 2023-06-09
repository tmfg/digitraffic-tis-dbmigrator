INSERT INTO tis_organization (business_id, name)
     VALUES ('2942108-7', 'Fintraffic Oy')
ON CONFLICT (business_id)
         DO UPDATE SET name = 'Fintraffic Oy';

INSERT INTO validation_ruleset (owner_id, category, identifying_name, description)
     VALUES ((SELECT id FROM tis_organization WHERE business_id = '2942108-7'),
             'generic',
             'gtfs.canonical.v4_0_0',
             'Canonical GTFS Validator by MobilityData, version v4.0.0')
    ON CONFLICT (identifying_name) DO NOTHING;
