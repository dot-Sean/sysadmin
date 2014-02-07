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

pkill -9 -U `id -u` osd_cat  2>&1 > /dev/null

date | osd_cat --delay $duration --lines 2 -c yellow --font $font --pos=bottom &
