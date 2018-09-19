#!/bin/bash

# Nagios thresholds
while getopts "w:c:" opt
do
	case $opt in
		w) warn=$OPTARG;;
		c) crit=$OPTARG;;
	esac
done

# Get network interfaces with real traffic
interfaces=$(ifconfig | grep -E "inet 172.|inet 10." -B1 | grep mtu | cut -f1 -d\:)

for interface in $interfaces; do 
	if $(ifconfig $interface | grep packets | grep -q "(0.0 B)")
	then
		# Do nothing
		:
	else
		rx0=$(ifconfig $interface | grep packets | grep RX | awk '{ print $5 }')
		tx0=$(ifconfig $interface | grep packets | grep TX | awk '{ print $5 }')

		sleep 1

		rx1=$(ifconfig $interface | grep packets | grep RX | awk '{ print $5 }')
		tx1=$(ifconfig $interface | grep packets | grep TX | awk '{ print $5 }')

		let "rx=rx1-rx0"
		let "tx=tx1-tx0"

		status="$rx $tx - $interface"

		if (( $warn <= $rx )) || (( $warn <= $tx ))
		then
		  if (( $crit <= $rx )) || (( $crit <= $tx ))
		  then
		    echo "CRITICAL - $status"
		  else
		    echo "WARNING - $status"
		  fi
		else
		  echo "OK - $status"
		fi
	fi
done
