#!/bin/bash

CONTAINER=$1

docker exec $CONTAINER apt-get update
docker exec $CONTAINER apt-get install -y zabbix-agent
zabbix_pid=$(docker exec $CONTAINER ps aux | grep zabbix | grep agent | awk '{print $2}' | sort  | head -n 1)
docker cp /home/app/conf/zabbix/zabbix_agentd.conf $CONTAINER:/etc/zabbix/zabbix_agentd.conf

if [[ $(ps aux | grep zabbix | grep agent | grep grep -v) ]]
	then 
		docker exec $CONTAINER kill -15 $zabbix_pid 2>/dev/null
		docker exec $CONTAINER /usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf 2>/dev/null
		docker exec $CONTAINER /etc/init.d/zabbix-agent start 2>/dev/null
	else
		docker exec $CONTAINER /usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf 2>/dev/null
		docker exec $CONTAINER /etc/init.d/zabbix-agent start 2>/dev/null
fi

# clean lib to decrease container size
docker exec $CONTAINER rm -rf /var/lib/apt/lists/* && rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive}