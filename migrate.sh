#!/bin/sh
for db in $(ls /usr/src/app/migrations); do
    database_url="$DATABASE_URL_BASE/$db"
    echo "Creating database $database_url"
    /usr/src/bin/sqlx database create --database-url "$database_url"
    echo "Migrating database $database_url"
    /usr/src/bin/sqlx migrate run --database-url "$database_url" --source "/usr/src/app/migrations/$db"
done
