#!/bin/bash -l

CLICKHOUSE=$(/usr/bin/clickhouse-server)
DATE=$(/bin/date +\%Y\%m\%d\%H)
DATADIR=$(/opt/clickhouse/data/)
BACKUPDIR=$(/opt/clickhouse/backups)
HOST=$(host -t axfr $(hostname -i | awk '{print $NF}') | grep PTR | awk '{print $NF}' | grep ch)
PORT=$(grep tcp_port /etc/clickhouse-server/config.xml | awk '{gsub(/[^0-9. ]/,"")}1')
BASES=$($CLICKHOUSE --client --port $PORT --host $HOST --query "show databases;" | grep -vE "default|system")

# Freeze pratitions
for BASE in $BASES; do
#	echo $BASE;
	TABLES=$($CLICKHOUSE --client --port $PORT --host $HOST --query "SELECT table FROM system.parts WHERE active AND database = '$BASE';"|sort -u)
        for table in $TABLES; do
#		echo $table;
                $CLICKHOUSE --client --port $PORT --host $HOST --database $BASE --query "ALTER TABLE $table FREEZE PARTITION '2';"
        done;
done;

echo "Freezing has been finished"

# Delete obsolete backups
echo "Deleting obsolete shadow dir"
find $DATADIR/shadow/ -mtime +7 -exec rm -r "{}" \;
echo "DONE!"
