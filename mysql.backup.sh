#!/bin/sh

### run this using crontab and set daily backup

SERVER=$1
PROJECT=$2
PART=$3
DIR=/home/lounges/$PROJECT
USERNAME=REPLICATION_USER_HERE
PASSWORD=YOUR_PASSWORD_HERE

#### stop replication
mysql -e 'STOP SLAVE;' -u$USERNAME -p$PASSWORD -h$SERVER

### create backup
#mysqldump --all-databases -u$USERNAME -p$PASSWORD -h$SERVER | gzip > $DIR/$PROJECT-$PART-`date +\%Y\%m\%d`.sql.gz
mysqldump --all-databases -u$USERNAME -p$PASSWORD -h$SERVER > $DIR/$PROJECT-$PART-`date +\%Y\%m\%d`.sql.gz

### start replication
mysql -e 'START SLAVE;' -u$USERNAME -p$PASSWORD -h$SERVER

#create gzip archive
#cd $DIR
#gzip $(ls -rt | grep $PART | tail -n1) > csgl-bets-`date +\%Y\%m\%d`.sql.gz

### create symlink to latest backup file
### It's requered to monitor backups
cd $DIR
rm $PROJECT-$PART-latest.sql > /dev/null 2>&1 # delete previous symlink
ln -s $(ls -rt | grep $PART | tail -n1) $PROJECT-$PART-latest.sql
