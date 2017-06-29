#!/bin/sh

set -eu

MYSQL_HOST_OPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"
databases=$(mysql $MYSQL_HOST_OPTS -e 'SHOW DATABASES;' --silent)

for database in $databases
do
  if [ "$database" != "information_schema" ]
  then
    echo "Creating backup for $database..."
    mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS $database \
      | gzip \
      | curl -X PUT \
             -H "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
             -T - \
             --silent \
             --output /dev/null \
             https://content.dropboxapi.com/1/files_put/auto/$DROPBOX_PREFIX$database.sql.gz
  fi
done
