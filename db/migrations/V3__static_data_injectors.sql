CREATE OR REPLACE FUNCTION upsert_ruleset(
    _business_id TEXT,
    _identifying_name TEXT,
    _description TEXT,
    _type TEXT,
    _category ruleset_category DEFAULT 'generic')
    RETURNS SETOF ruleset
    LANGUAGE plpgsql
AS
$$
DECLARE
BEGIN
    RETURN QUERY
        INSERT INTO ruleset (owner_id, category, identifying_name, description, type)
            VALUES ((SELECT id FROM organization WHERE business_id = _business_id),
                    _category,
                    _identifying_name,
                    _description,
                    _type)
            ON CONFLICT (identifying_name)
                DO UPDATE SET category = _category,
                    owner_id = (SELECT id FROM organization WHERE business_id = _business_id),
                    description = _description,
                    type = _type
            RETURNING *;
END
$$;
