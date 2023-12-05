ALTER TABLE error ADD COLUMN severity TEXT NOT NULL DEFAULT 'UNKNOWN';

CREATE TABLE rule_severity_override
(
    ruleset_id BIGINT NOT NULL,
    name       TEXT   NOT NULL,
    severity   TEXT   NOT NULL,
    UNIQUE (ruleset_id, name),
    CONSTRAINT fk_rule_severity_override_ruleset_ruleset_id FOREIGN KEY (ruleset_id) REFERENCES ruleset (id)
);
