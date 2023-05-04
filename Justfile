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
    flyway/flyway:9 {{cmd}}

# Run database migrations
migrate: (flyway "migrate")

# Print migration details
info: (flyway "info")

# Reset database
reset: (flyway "clean")
