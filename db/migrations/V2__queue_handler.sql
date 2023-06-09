CREATE TABLE queue_entry
(
    id          BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (START WITH 1000000 INCREMENT BY 1),
    public_id   TEXT UNIQUE NOT NULL DEFAULT nanoid(),
    "format"    TEXT        NOT NULL,
    url         TEXT        NOT NULL,
    business_id TEXT        NOT NULL,
    etag        TEXT,
    metadata    JSONB,
    started   TIMESTAMP(3),
    updated   TIMESTAMP(3),
    completed TIMESTAMP(3)
);

CREATE TABLE queue_phase
(
    id        BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (START WITH 1100000 INCREMENT BY 1),
    entry_id  BIGINT       NOT NULL,
    "name"    TEXT         NOT NULL,
    started   TIMESTAMP(3) NOT NULL DEFAULT NOW(),
    updated   TIMESTAMP(3),
    completed TIMESTAMP(3),
    CONSTRAINT fk_queue_step_queue_entry_entry_id FOREIGN KEY (entry_id) REFERENCES queue_entry (id) ON DELETE CASCADE,
    UNIQUE (entry_id, name)
);

CREATE INDEX idx_queue_phase_name ON queue_phase
(
    name
);

CREATE TABLE queue_validation_input
(
    id       BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (START WITH 1200000 INCREMENT BY 1),
    entry_id BIGINT NOT NULL,
    CONSTRAINT fk_queue_validation_input_queue_entry_entry_id FOREIGN KEY (entry_id) REFERENCES queue_entry (id) ON DELETE CASCADE
);

CREATE TABLE queue_conversion_input
(
    id       BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (START WITH 1300000 INCREMENT BY 1),
    entry_id BIGINT NOT NULL,
    CONSTRAINT fk_queue_conversion_input_queue_entry_entry_id FOREIGN KEY (entry_id) REFERENCES queue_entry (id) ON DELETE CASCADE
);

CREATE TABLE queue_generated_file
(
    id       BIGINT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY (START WITH 1400000 INCREMENT BY 1),
    entry_id BIGINT NOT NULL,
    path     TEXT   NOT NULL,
    CONSTRAINT fk_queue_generated_file_queue_entry_entry_id FOREIGN KEY (entry_id) REFERENCES queue_entry (id) ON DELETE CASCADE
);


