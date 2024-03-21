-- entry doesn't need to be able to directly reference findings from its tasks, we can use tasks to find those out
ALTER TABLE finding
 DROP COLUMN entry_id;
