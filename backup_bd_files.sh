mkdir $TEMP_DIRECTORY
lftp sftp://$REMOTE_SSH_USER:$BPASSWORD@$REMOTE_IP -e "mirror -e  $REMOTE_DIRECTORY $TEMP_DIRECTORY ; quit"
mkdir $SQLDUMPS_DIRECTORY/
DBS="$(mysql --user=$LOCAL_SQL_USER --password=$LOCAL_SQL_PASSWORD -Bse 'show databases;')"
for DB in $DBS
do
	mysqldump -host=$REMOTE_IP --user=$REMOTE_SQL_USER --password=$REMOTE_SQL_PASSWORD --databases $DB > $SQLDUMPS_DIRECTORY/$DB.sql  
done
tar -jcvf $TEMP_DIRECTORY.tar.bz2 $TEMP_DIRECTORY
rm -rf $TEMP_DIRECTORY
