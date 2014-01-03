#!/bin/sh
#
# ntpmonitor.sh
#
# nellinux@rocketmail.com
#


start_ntpd() {
    echo 'Starting ntpd ...'
    /etc/rc.d/rc.ntpd start
    sleep 2
    grep 'ntpd' /var/log/messages | tail -10
}

update_clock() {
    echo 'Updating clock ...'
    ps -C ntpd > /dev/null && /etc/rc.d/rc.ntpd stop
    ntpdate ntp.dipvvf.it
    /etc/rc.d/rc.ntpd start
}

if ps -C ntpd > /dev/null ; then
    echo 'ntpd ok'
    offset=$(ntpq -p | grep '10.251' | tr -s ' ' | cut -d' ' -f10 | sed 's/\..*//')
    echo "Offset is $offset"
    if [ $offset -gt 10 ]; then
        echo 'Too big !!'
        update_clock
    fi
else
    echo 'ntpd is not running; why?'
    grep 'peers refreshed' /var/log/messages | tail -1
    start_ntpd
fi
