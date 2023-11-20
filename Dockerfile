FROM flyway/flyway:9

COPY --chown=flyway:flyway db/migrations /flyway/sql
COPY --chown=flyway:flyway db/flyway.conf /flyway/conf/flyway.conf
### remove additional JDBC drivers and other unused tools to reduce image size and security alerts
# keep only postgresql driver
RUN find /flyway/drivers -type f \! -name 'postgresql-*.jar' -delete
# remove Azure AD support
RUN rm -rf /flyway/lib/aad
# remove Oracle Wallet
RUN rm -rf /flyway/lib/oracle_wallet
