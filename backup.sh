#!/bin/sh

set -eu

MYSQL_HOST_OPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"

echo "Creating backup for $MYSQL_DATABASE..."
mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS $MYSQL_DATABASE > $MYSQL_DATABASE.sql
gzip -f $MYSQL_DATABASE.sql

echo "Upload backup to dropbox..."
curl -X POST https://content.dropboxapi.com/2/files/upload \
     --header "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
     --header "Dropbox-API-Arg: {\"path\": \"/$DROPBOX_PREFIX$MYSQL_DATABASE.sql.gz\",\"mode\": \"overwrite\",\"autorename\": true,\"mute\": true}" \
     --header "Content-Type: application/octet-stream" \
     --data-binary @"$MYSQL_DATABASE.sql.gz"

rm $MYSQL_DATABASE.sql.gz
