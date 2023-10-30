-- Add transit data format as referencable enum with system supported formats and set is as explicit requirement for
-- rulesets.
-- This info is used in ruleset selection and general format support detection.
-- These are not meant to be full metadata of what are the supported formats, who maintains them etc, use your favorite
-- search engine for that.
CREATE TYPE transit_data_format AS ENUM ('gtfs', 'gtfs-rt', 'netex', 'siri');

ALTER TABLE ruleset
    ADD COLUMN format transit_data_format NOT NULL DEFAULT 'gtfs'::transit_data_format;
