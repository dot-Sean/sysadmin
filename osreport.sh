#!/bin/sh
#
# sysadmin/osreport.sh
#
# Puts informations on screen
#
# 2014 Jan 28 - nellinux@rocketmail.com


pkill -9 -U `id -u` osd_cat  2>&1 > /dev/null

date | osd_cat -d $duration -l5 -c yellow -f $font &

mutt -Z  || echo  'No mail' | osd_cat -d $duration -f $font -c blue -o13
