-- Add several indices based on queries we now have and data access patterns.
-- Generally the default B-Tree is used, but in some cases other algorithms, mainly BRIN, is chosen as it fits the data
-- at hand better.
CREATE INDEX idx_error_entry_id ON error USING brin (entry_id);
CREATE INDEX idx_error_task_id ON error USING brin (task_id);
CREATE INDEX idx_task_entry_id ON task (entry_id);
CREATE INDEX idx_package_task_id ON package (task_id);
CREATE INDEX idx_partnership_partner_a_id ON partnership (partner_a_id);
CREATE INDEX idx_partnership_partner_b_id ON partnership (partner_b_id);
