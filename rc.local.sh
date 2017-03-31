#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.


#Iptables
F="/etc/network/iptables.save"
test -f "$F" && /sbin/iptables-restore < $F

#Zabbix-agent
if [ -f /etc/init.d/zabbix-agent ]; then
        /etc/init.d/zabbix-agent restart
fi

#Nginx
if [ -f /etc/init.d/nginx ]; then
        /etc/init.d/nginx restart
fi

#fail2ban
if [ -f /var/run/fail2ban/fail2ban.sock ]; then
        fail2ban-client start
fi

#PPTP
/etc/init.d/pptpd start

exit 0