-- Drop the BRIN index
DROP INDEX IF EXISTS idx_finding_task_id;
-- Recreate B-tree index
CREATE INDEX idx_finding_task_id ON finding (task_id);
