#!/bin/sh
#
# sysadmin/osreport.sh
#
# Puts informations on screen
#
# 2014 Jan 28 - nellinux@rocketmail.com


export DISPLAY=":0"

duration=10

font=-*-terminus-medium-*-*-*-*-180-*-*-*-*-*-*



#
# Dependencies
#

for d in osd_cat xprop pkill; do
    type $d > /dev/null || exit 1
done


#
# Functions
#
get_ws_name() {
wsname=$(xprop -root _NET_CURRENT_DESKTOP \
    _NET_NUMBER_OF_DESKTOPS \
    _NET_DESKTOP_NAMES | \
    awk '
        /_NET_CURRENT_DESKTOP/ { current = $3 + 1; }
        /_NET_NUMBER_OF_DESKTOPS/ { no_ws = $3; }
        /_NET_DESKTOP_NAMES/ { for (i = 3; i < no_ws + 3; i++) {
                                 names[i - 3] = $i;
                                 gsub( "\"|,", " ", names[i - 3]);
                                 gsub ("[[:space:]]*", "", names[i - 3]);
                               };
                             };
        END {
          print names[current - 1]" "current"/"no_ws;
        };')

}


pkill -9 -U `id -u` osd_cat  2>&1 > /dev/null

get_ws_name
d=`date | sed 's/CET.*//'`

echo -e "$d\n$wsname"  | osd_cat --delay $duration --lines 2 -c yellow --font $font --pos=bottom &
