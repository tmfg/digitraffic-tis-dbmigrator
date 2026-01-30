FROM flyway/flyway:11.20.2-alpine

COPY --chown=flyway:flyway db/migrations /flyway/sql
COPY --chown=flyway:flyway db/flyway.conf /flyway/conf/flyway.conf
