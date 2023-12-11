-- require package task_id+name combos to be unique to prevent generating more than one pair and accidentally overwriting
-- something
ALTER TABLE package
    ADD CONSTRAINT c_package_task_id_name UNIQUE (task_id, name);
