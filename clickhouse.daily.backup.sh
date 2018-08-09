#!/bin/bash

DATE=$(/bin/date +\%Y\%m\%d\%H)
DATADIR='/opt/clickhouse/data/'
BACKUPDIR='/opt/clickhouse/backups'
HOST=$(host -t axfr $(hostname -i | awk '{print $NF}') | grep PTR | awk '{print $NF}' | grep com)
PORT=$(grep tcp_port /etc/clickhouse-server/config.xml | awk '{gsub(/[^0-9. ]/,"")}1')
BASES=$(clickhouse-server --client --port $PORT --host $HOST --query "show databases;" | grep -vE "default|system")

# Freeze pratitions
for BASE in $BASES; do
        TABLES=$(clickhouse-server --client --port $PORT --host $HOST --query "SELECT table FROM system.parts WHERE active AND database = '$BASE';"|sort -u)
        for table in $TABLES; do
                clickhouse-server --client --port $PORT --host $HOST --database $BASE --query "ALTER TABLE $table FREEZE PARTITION '2';"
        done;
done;

# Copy backups & metadata
if mkdir $BACKUPDIR/$DATE && chown -R clickhouse:clickhouse $BACKUPDIR/$DATE 
       then cp -r $DATADIR/shadow $BACKUPDIR/$DATE
fi 
if mkdir $BACKUPDIR/$DATE_metadata && chown -R clickhouse:clickhouse $BACKUPDIR/$DATE_metadata
       then cp -r $DATADIR/metadata $BACKUPDIR/$DATE_metadata
fi

# Delete obsolete backups
find $DATADIR/shadow/ -mtime +7 -delete
find $BACKUPDIR/ -mtime +7 -delete
