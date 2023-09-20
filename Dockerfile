FROM flyway/flyway:9

COPY --chown=flyway:flyway db/migrations /flyway/sql
COPY --chown=flyway:flyway db/flyway.conf /flyway/conf/flyway.conf
