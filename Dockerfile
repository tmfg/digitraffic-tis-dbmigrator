FROM flyway/flyway:11.20.2-alpine AS app

COPY --chown=flyway:flyway db/migrations /flyway/sql
COPY --chown=flyway:flyway db/flyway.conf /flyway/conf/flyway.conf

# Generate SBOM
FROM aquasec/trivy:latest AS sbom-generator
COPY --from=app / /scanroot
RUN trivy rootfs --format cyclonedx --output /bom.json /scanroot

# Copy SBOM
FROM app
ARG GITHUB_SHA
COPY --from=sbom-generator /bom.json /sbom/${GITHUB_SHA}.json
