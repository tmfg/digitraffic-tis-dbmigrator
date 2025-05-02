-- 1. create needed role for view maintenance
DO
$$
    BEGIN
        IF NOT EXISTS (
            SELECT FROM pg_catalog.pg_roles
            WHERE rolname = 'maintain_materialized_views'
        ) THEN
            CREATE ROLE maintain_materialized_views;
        END IF;
    END
$$;

-- 2. grants for 'statistics' view's dependent tables
GRANT SELECT ON entry TO maintain_materialized_views;
GRANT SELECT ON task TO maintain_materialized_views;

-- 3. create special type and function for creating the necessary DDL on demand
DROP TYPE IF EXISTS view_maintenance CASCADE;
CREATE TYPE view_maintenance AS
(
    view_name   TEXT,
    maintainers TEXT[]
);

CREATE OR REPLACE FUNCTION allow_materialized_view_management(
    _view_maintainers view_maintenance[]
)
    RETURNS SETOF view_maintenance AS
$$
DECLARE
    vm view_maintenance;
    maintainer TEXT;
    action_taken BOOLEAN;
BEGIN
    FOR vm IN SELECT * FROM unnest(_view_maintainers)
        LOOP
            action_taken := FALSE;
            EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON %I TO maintain_materialized_views', vm.view_name);
            -- 4. grant users privileges to the maintenance role
            FOREACH maintainer IN ARRAY vm.maintainers
                LOOP
                    IF EXISTS (SELECT 1
                               FROM pg_roles
                               WHERE rolname = maintainer)
                    THEN
                        EXECUTE format('GRANT maintain_materialized_views TO %I', maintainer);
                        action_taken := TRUE;
                    END IF;
                END LOOP;
            EXECUTE format('ALTER TABLE %I OWNER TO maintain_materialized_views', vm.view_name);
            action_taken := TRUE;
            IF action_taken THEN
                RETURN NEXT vm;
            END IF;
        END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT allow_materialized_view_management(ARRAY [
    ('statistics', ARRAY [CURRENT_USER, 'vaco'])
    ]::view_maintenance[]);
