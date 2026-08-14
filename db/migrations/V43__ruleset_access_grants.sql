CREATE TABLE ruleset_access
(
    company_id BIGINT NOT NULL,
    ruleset_id BIGINT NOT NULL,
    UNIQUE (company_id, ruleset_id),
    CONSTRAINT fk_ruleset_access_company_id FOREIGN KEY (company_id) REFERENCES company (id) ON DELETE CASCADE,
    CONSTRAINT fk_ruleset_access_ruleset_id FOREIGN KEY (ruleset_id) REFERENCES ruleset (id) ON DELETE CASCADE
);

CREATE INDEX idx_ruleset_access_company_id ON ruleset_access (company_id);
CREATE INDEX idx_ruleset_access_ruleset_id ON ruleset_access (ruleset_id);

-- Backfill: every current owner gets an equivalent grant, preserving today's effective access
INSERT INTO ruleset_access (company_id, ruleset_id)
SELECT owner_id, id
  FROM ruleset;
