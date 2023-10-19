-- remove organization public id as redundant field, business id is already a public id
ALTER TABLE organization
 DROP COLUMN IF EXISTS public_id CASCADE;
