#!/bin/bash
HOSTNAME=`hostname`
TINCS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $3 }'`
for TINC in $TINCS
do
   tincd -n $TINC
   sleep 2
done
