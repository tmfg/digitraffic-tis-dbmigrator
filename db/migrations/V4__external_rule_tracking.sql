-- add metadata columns for tracking where the error originated from
ALTER TABLE error
ADD COLUMN source TEXT NOT NULL DEFAULT '';

