#!/bin/bash

warn=$1
crit=$2

interface="eth1.3180"

i0=$(netstat -i | grep $interface)
rx0=$(ifconfig $interface | grep packets | grep RX | awk '{ print $5 }')
tx0=$(ifconfig $interface | grep packets | grep TX | awk '{ print $5 }')

sleep 1

i1=$(netstat -i | grep $interface)
rx1=$(ifconfig $interface | grep packets | grep RX | awk '{ print $5 }')
tx1=$(ifconfig $interface | grep packets | grep TX | awk '{ print $5 }')

let "rx=rx1-rx0"
let "tx=tx1-tx0"

status="$rx $tx"

if (( $warn <= $rx )) || (( $warn <= $tx ))
then
  if (( $crit <= $rx )) || (( $crit <= $tx ))
  then
    echo "CRITICAL - $status"
    exit 2
  else
    echo "WARNING - $status"
    exit 1
  fi
else
  echo "OK - $status"
  exit 0
fi
