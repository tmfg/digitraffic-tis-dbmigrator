-- This was an oversight when originally creating the feature, the names of flags should be unique to avoid re-creating
-- the same flag on every startup with different value.

-- First, remove duplicates, keeping oldest as that is the intended record.
   DELETE
     FROM feature_flag e
    WHERE id IN (SELECT ff.id AS id
                   FROM (SELECT ff.id,
                                ROW_NUMBER() OVER (PARTITION BY name ORDER BY modified ASC) r
                           FROM feature_flag ff) AS ff
                  WHERE ff.r > 1);

-- Then, add unique constraint for the remaining
ALTER TABLE feature_flag
    ADD CONSTRAINT c_feature_flag_name UNIQUE (name);
