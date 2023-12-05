-- Track completion statuses for entries and tasks
CREATE TYPE status AS ENUM ('errors', 'failed', 'processing', 'received', 'success', 'warnings');

ALTER TABLE task
    ADD COLUMN status status NOT NULL DEFAULT 'received';

ALTER TABLE entry
    ADD COLUMN status status NOT NULL DEFAULT 'received';
