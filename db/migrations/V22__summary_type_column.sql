CREATE TYPE summary_renderer_type AS ENUM ('card', 'tabular', 'list', 'unknown');

ALTER TABLE summary
    ADD COLUMN renderer_type summary_renderer_type NOT NULL DEFAULT 'unknown'::summary_renderer_type;
