#!/bin/bash
HOSTNAME=`hostname`
TORS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $6 }'`
for TOR in $TORS
do
   TINC=`cat ~/host-information.txt | grep -e $HOSTNAME | grep -e $TOR | awk -F "|" '{ print $3 }'`
   cat /var/lib/$TOR/$TINC/hostname
   sleep 1
done
