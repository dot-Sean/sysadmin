#!/bin/sh
#
# tnx@giovanas
#
# May 10, 2014

date
echo '----'
last | head
echo '----'

/sbin/mdadm --detail /dev/md0
echo '----'
/sbin/ifconfig eth0 | head -2
/sbin/ifconfig eth1 | head -2



