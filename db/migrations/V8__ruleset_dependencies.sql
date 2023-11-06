-- Rulesets can declare by name a set of dependencies (other rulesets, rules or tasks) which should be run before the
-- ruleset itself can be run.
-- The dependencies are referred to as strings and are to be considered informal. VACO backend logic is responsible for
-- resolving and acting on the declared dependencies, and it is possible they are ignored.
ALTER TABLE ruleset
    ADD COLUMN IF NOT EXISTS dependencies TEXT[] DEFAULT array[]::text[];
