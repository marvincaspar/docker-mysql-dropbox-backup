#!/bin/sh

set -eu

MYSQL_HOST_OPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"

echo "Creating backup for $MYSQL_DATABASE..."
mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS $MYSQL_DATABASE \
  | gzip \
  | curl -X PUT \
         -H "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
         -T - \
         --silent \
         --output /dev/null \
         https://content.dropboxapi.com/1/files_put/auto/$DROPBOX_PREFIX$MYSQL_DATABASE.sql.gz
