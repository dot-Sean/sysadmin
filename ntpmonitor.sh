#!/bin/sh
#
# ntpmonitor.sh
#
# nellinux@rocketmail.com
#


###############################################################################
# Configs                                                                     #
###############################################################################

ntpserver=`grep '^server' /etc/ntp.conf | tail -n1 | tr -s ' ' | cut -f2 -d' '`
bigoffset=15


###############################################################################
# Constants                                                                   #
###############################################################################

EXIT_SUCCESS=0
NOOP=0
APP_NAME=($basename $0)

###############################################################################
# Functions                                                                   #
###############################################################################

log() {
    echo "[$APP_NAME `date +%T`] $1"
    logger $1 -t $APP_NAME
}


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

usage() {
cat <<EOF
  USAGE:
    $(basename $0) [OPTIONS]

  OPTIONS:
     -f    force system time from $ntpserver
     -h    this help
EOF
}



###############################################################################
# MAIN                                                                        #
###############################################################################

while getopts ":hf" option; do
  case $option in

      f)  update_clock
          exit $EXIT_SUCCESS
          ;;

      h)  usage
          exit $EXIT_SUCCESS
          ;;
  esac
done

shift $(($OPTIND - 1))




###############################################################################
# MAIN                                                                        #
###############################################################################

if ps -C ntpd > /dev/null ; then
    echo 'ntpd ok'
    offset=$(ntpq -p | tail -n1 | sed 's/^[ *]//' | tr -s ' ' | cut -d' ' -f9 | sed 's/\..*//')
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
