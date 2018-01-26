#!/bin/bash
# It is run from preprod
# It starts periodically with /etc/crontab. How often it depeneds on your backups size.
# Run this script by user which has permissions to remote located backups
# Run this script: /bin/bash mysql.copy.and.upload.dump.sh &> /tmp/copy.and.upload.mysql.dumps.log

BACKUPSERVER='127.0.0.1'
USER=$(whoami)
DBLIST='mydatabase'
#LOG=/tmp/copy.and.upload.mysql.dumps.log
DBUSER=$(whoami)
DBPASSWORD=$(cat /home/$(whoami)/.mysql_credentials)#chmod 700 to this file /home/$(whoami)/.mysql_credentials

#init loggin
echo "==== Started at $(date) ===="

#Copying dumps from backup server: each of 4 projects
echo "==== Copying dumps ($(date)) ===="

for i in $DBLIST;
do
  REQUESTEDFILE=$(ssh $USER@$BACKUPSERVER "readlink -f /home/$USER/$(echo $i | cut -f1 -d \-)/$i-latest.sql")
  scp $USER@$BACKUPSERVER:$REQUESTEDFILE /home/$USER/
done

#Unzip each .gz dump
echo "==== Unpacking... ($(date)) ===="

cd /home/$USER/

for i in $(ls /home/$USER/*.sql.gz);
do
  /bin/gzip -d $i #/home/$USER/$($(basename $i)|cut -f1 -d\.).sql
done


#Rename database in dumpfile and upload to MySQL
echo "==== Replacing DB's names ($(date)) ===="

cd /home/$USER/
sed -i 's/foo/bar/g' mydatabase*.sql

echo "==== Uploading dumps to mysql ($(date)) ===="

#Upload
mysql -u$DBUSER -p$DBPASSWORD -D mydatabase -o < mydatabase*.sql

#Clean up the mess
echo "==== Removing temporary files ($(date)) ===="

for i in $(ls /home/$USER/*sql);
do
  ls -l $i
#rm $i
done

echo "==== Finished at $(date) ===="