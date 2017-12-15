#!/bin/bash
# It is run from preprod
# It starts periodically with /etc/crontab. How often it depeneds on your backups size.
# Run this script by user which has permissions to remote located backups
# Run this script: /bin/bash mysql.copy.and.upload.dump.sh &> /tmp/copy.and.upload.mysql.dumps.log

BACKUPSERVER='149.202.209.56'
USER=$(whoami)
DBLIST='csgl-trades csgl-bets d2l-trades d2l-bets'
#LOG=/tmp/copy.and.upload.mysql.dumps.log
DBUSER=$(whoami)
DBPASSWORD=$(cat /home/$(whoami)/.mysql_credentials)#chmod 700 to this file /home/$(whoami)/.mysql_credentials

#init loggin
echo "==== Started at $(date) ===="

#Copying dumps from backup server: each of 4 projects
echo "==== Copying dumps ($(date)) ===="

for i in $DBLIST;
do
  REQUESTEDFILE=$(ssh $USER@$BACKUPSERVER "readlink -f /home/lounges/$(echo $i | cut -f1 -d \-)/$i-latest.sql")
  scp $USER@$BACKUPSERVER:$REQUESTEDFILE /home/$USER/
done

#Unzip each .gz dump
echo "==== Unpacking... ($(date)) ===="

cd /home/$USER/

for i in $(ls /home/$USER/*.sql.gz);
do
  /bin/gzip -d $i #/home/$USER/$($(basename $i)|cut -f1 -d\.).sql
done

#| cs_bets|cslounge
#| cs_memory  |
#| cs_trades  |cslounge
#| d2_bets|bets
#| d2_trades  |dota2lounge

#Rename database in dumpfile and upload to MySQL
echo "==== Replacing DB's names ($(date)) ===="

cd /home/$USER/
sed -i 's/bets/d2_bets/g' d2l-bets*.sql
sed -i 's/dota2lounge/d2_trades/g' d2l-trades*.sql
sed -i 's/cslounge/cs_bets/g' csgl-bets*.sql
sed -i 's/cslounge/cs_trades/g' csgl-trades*.sql

echo "==== Uploading dumps to mysql ($(date)) ===="

#D2L-Bets
mysql -u$DBUSER -p$DBPASSWORD -D d2_bets -o < d2l-bets*.sql

#D2L-Trades
mysql -u$DBUSER -p$DBPASSWORD -D d2_trades -o < d2l-trades*.sql

#CSGO-Bets
mysql -u$DBUSER -p$DBPASSWORD -D cs_bets -o < csgl-bets*.sql

#CSGO-Trades
mysql -u$DBUSER -p$DBPASSWORD -D cs_trades -o < csgl-trades*.sql

#Clean up the mess
echo "==== Removing temporary files ($(date)) ===="

for i in $(ls /home/$USER/*sql);
do
  ls -l $i
#rm $i
done

echo "==== Finished at $(date) ===="