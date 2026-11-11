-- Missing indices on FK columns caused cascade deletes (company -> context -> entry -> task -> ...)
-- to sequentially scan child tables per deleted parent row. Also used directly by app queries
-- (e.g. listing a company's entries).
CREATE INDEX IF NOT EXISTS idx_validation_input_entry_id ON validation_input (entry_id);
CREATE INDEX IF NOT EXISTS idx_conversion_input_entry_id ON conversion_input (entry_id);
CREATE INDEX IF NOT EXISTS idx_entry_context_id ON entry (context_id);
CREATE INDEX IF NOT EXISTS idx_entry_business_id ON entry (business_id);
CREATE INDEX IF NOT EXISTS idx_summary_task_id ON summary (task_id);
