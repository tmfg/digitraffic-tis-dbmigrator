# Lists available Just recipes
default:
  @just --list --justfile {{justfile()}}

# Execute Flyway container target with local customizations
[private]
flyway cmd="help":
  docker run \
    --rm \
    -v {{justfile_directory()}}/db/migrations:/flyway/sql \
    -v {{justfile_directory()}}/db/flyway.conf:/flyway/conf/flyway.conf:ro \
    -e FLYWAY_URL='jdbc:postgresql://host.docker.internal:54321/vaco' \
    -e FLYWAY_USER=postgres \
    -e FLYWAY_PASSWORD=dwULL632mdJZ \
    flyway/flyway:9 {{cmd}}

# Run database migrations
migrate: (flyway "migrate")

# Print migration details
info: (flyway "info")

# Repair schema history, use if migrations conflict due to checksum mismatch
repair: (flyway "repair")

# Reset database
reset: (flyway "clean")
