mysqldump -host=$REMOTE_IP --user=$REMOTE_SQL_USER --password=$REMOTE_SQL_PASSWORD --databases  $DB > $SQLDUMPS_DIRECTORY/$DB.sql
