#!/bin/sh

# Parametrage des fichiers
BACKUP_DIRECTORY=/home/backups
TEMP_DIRECTORY=$BACKUP_DIRECTORY/$(date +%Y-%m-%d)
SQLDUMPS_DIRECTORY=$TEMP_DIRECTORY/__SQL_DUMPS__
LOG_FILE=$TEMP_DIRECTORY.log
LOCAL_DIRECTORY=/var/www
LOCAL_SQL_USER=username
LOCAL_SQL_PASSWORD=password

# Acces au serveur distant
REMOTE_IP=192.168.0.1
REMOTE_SSH_USER=username
REMOTE_SSH_PASSWORD=password
REMOTE_DIRECTORY=/var/www
REMOTE_SQL_USER=username
REMOTE_SQL_PASSWORD=password

# Copie des fichiers locaux
echo "[$(date +%d/%m/%Y-%H:%M)] Sauvegarde des fichiers locaux" >> $LOG_FILE
cp -R $LOCAL_DIRECTORY $TEMP_DIRECTORY >> $LOG_FILE

# Mise a jour des fichiers locaux
echo "[$(date +%d/%m/%Y-%H:%M)] Mise a jour des fichiers" >> $LOG_FILE
lftp sftp://$REMOTE_SSH_USER:$BPASSWORD@$REMOTE_IP -e "mirror -e  $REMOTE_DIRECTORY $LOCAL_DIRECTORY ; quit" >> $LOG_FILE

# Copie des bases de donnees locales et mise a jour
echo "[$(date +%d/%m/%Y-%H:%M)] Sauvegarde et mise a jour des bases de donnees locales" >> $LOG_FILE
mkdir $SQLDUMPS_DIRECTORY/
DBS="$(mysql --user=$LOCAL_SQL_USER --password=$LOCAL_SQL_PASSWORD -Bse 'show databases;')"
for DB in $DBS
do
	echo " -> "$DB >> $LOG_FILE
  	mysqldump --user=$LOCAL_SQL_USER --password=$LOCAL_SQL_PASSWORD $DB > $SQLDUMPS_DIRECTORY/$DB.sql  
	mysqldump -host=$REMOTE_IP --user=$REMOTE_SQL_USER --password=$REMOTE_SQL_PASSWORD --databases $DB | mysql --user=$LOCAL_SQL_USER --password=$LOCAL_SQL_PASSWORD
done

# Compression de la sauvegarde
echo "[$(date +%d/%m/%Y-%H:%M)] Compression de la sauvegarde" >> $LOG_FILE
tar -jcvf $TEMP_DIRECTORY.tar.bz2 $TEMP_DIRECTORY

# Suppression du repertoire de sauvegarde
echo "[$(date +%d/%m/%Y-%H:%M)] Suppression du repertoire de sauvegarde" >> $LOG_FILE
rm -rf $TEMP_DIRECTORY
