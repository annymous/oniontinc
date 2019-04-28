#!/bin/bash
HOSTNAME=`hostname`
TINCS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $3 }'`
for TINC in $TINCS
do
   echo $TINC | sudo tee -a /etc/tinc/nets.boot
   sleep 1
done
