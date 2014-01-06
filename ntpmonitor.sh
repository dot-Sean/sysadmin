#!/bin/sh
#
# ntpmonitor.sh
#
# nellinux@rocketmail.com
#

ntpserver=`grep '^server' /etc/ntp.conf | tail -n1 | tr -s ' ' | cut -f2 -d' '`
bigoffset=15

start_ntpd() {
    echo 'Starting ntpd ...'
    /etc/rc.d/rc.ntpd start
    sleep 2
    grep 'ntpd' /var/log/messages | tail -10
}

update_clock() {
    echo 'Updating clock ...'
    ps -C ntpd > /dev/null && /etc/rc.d/rc.ntpd stop
    ntpdate $ntpserver
    /etc/rc.d/rc.ntpd start
}

if ps -C ntpd > /dev/null ; then
    echo 'ntpd ok'
    offset=$(ntpq -p | tail -n1 | tr -s ' ' | cut -d' ' -f9 | sed 's/\..*//')
    echo "Offset is $offset"
    if [ $offset -gt $bigoffset ]; then
        echo 'Too big !!'
        update_clock
    fi
else
    echo 'ntpd is not running; why?'
    grep 'peers refreshed' /var/log/messages | tail -1
    start_ntpd
fi
