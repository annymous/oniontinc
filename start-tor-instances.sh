#!/bin/bash
HOSTNAME=`hostname`
TORRCS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $7 }'`
for TORRC in $TORRCS
do
   sudo -u debian-tor tor -f /etc/tor/$TORRC
   sleep 5
done
