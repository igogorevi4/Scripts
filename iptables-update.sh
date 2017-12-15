#!/bin/sh
#####################################
#          Config Firewall          #
#####################################

IPTABLES="/sbin/iptables"
MODPROBE="/sbin/modprobe"

#
# reset the default policies in the filter table.
#
echo "Flush iptables"
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT ACCEPT
#
# reset the default policies in the nat table.
#
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT ACCEPT
#
# reset the default policies in the mangle table.
#
$IPTABLES -t mangle -P PREROUTING ACCEPT
$IPTABLES -t mangle -P OUTPUT ACCEPT
#
# flush all the rules in the filter and nat tables.
#
$IPTABLES -F
$IPTABLES -t nat -F
$IPTABLES -t mangle -F
#
# erase all chains that's not default in filter and nat table.
#
$IPTABLES -X
$IPTABLES -t nat -X
$IPTABLES -t mangle -X

#
# Set policies
#
echo "Set policies"
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT

echo "ICMP Rules"
#
# ICMP ACCEPT rules
#

$IPTABLES -A INPUT -p ICMP -i eth0 --icmp-type echo-request -j ACCEPT
$IPTABLES -A INPUT -p ICMP -i eth0 --icmp-type time-exceeded -j ACCEPT
$IPTABLES -A INPUT -p ICMP -i eth0 --icmp-type destination-unreachable -j ACCEPT

echo "Drop not our subnets"
#
# Packets to drop not our subnets
#

#$IPTABLES -A INPUT -p ALL -i eth* -d 192.168.0.0/16 -j DROP
$IPTABLES -A INPUT -p ALL -i eth* -d 10.0.0.0/8 -j DROP
$IPTABLES -A INPUT -p ALL -i eth* -d 172.16.0.0/12 -j DROP
$IPTABLES -A INPUT -p ALL -i eth* -d 169.254.0.0/16 -j DROP

echo "TCP Accept Rules"
#
# TCP ACCEPT rules
#

#l0
$IPTABLES -A INPUT -i lo  -d 127.0.0.1 -j ACCEPT
$IPTABLES -A OUTPUT -o lo -s 127.0.0.1 -j ACCEPT

#Default
$IPTABLES -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#HTTP
#$IPTABLES -A INPUT -p TCP --dport 80 -j ACCEPT

#HTTPS
#$IPTABLES -A INPUT -p TCP --dport 443 -j ACCEPT

#SSH
#$IPTABLES -A INPUT -p TCP --dport 22 -j ACCEPT

#
#FTP
#
#$MODPROBE nf_conntrack_ftp

#$IPTABLES -A INPUT -p tcp -m conntrack --ctstate NEW -m tcp --dport 21 -s 192.168.0.1 -m comment --comment "Allow ftp connections to CSGL backends" -j ACCEPT

#VPN (PPTPd)
#$IPTABLES -A INPUT -p TCP --dport 1723 -j ACCEPT
#$IPTABLES -t nat -A POSTROUTING -o eth0 -j MASQUERADE
##$IPTABLES -A FORWARD -i ppp0 -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "IP Filter Rules"
#
# IP Filter Rules
#

#Office IP
$IPTABLES -A INPUT -p ALL -s 10.10.10.10 -j ACCEPT  -m comment --comment "Allow connection from office's IP"

#Zabbix
$IPTABLES -A INPUT -p ALL -s 127.0.0.1 -j ACCEPT

iptables-save

#Save iptables for upstart. Do not forget add this to /etc/rc.local:
#F="/etc/network/iptables.save"
#test -f "$F" && /sbin/iptables-restore < $F
iptables-save > /etc/network/iptables.save
#iptables-save > /etc/iptables.up.rules
#echo "pre-up iptables-restore < /etc/iptables.up.rules" >> /etc/network/interfaces