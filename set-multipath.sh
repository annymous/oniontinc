#!/bin/bash
HOSTNAME=`hostname`
TINCS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $3 }'`
ETHS=`ip a | grep -e "BROADCAST" | tr ':' ' ' | awk '{ print $2 }'`

for ETH in $ETHS
do
   ip link set dev $ETH multipath off
done

for TINC in $TINCS
do
   ip link set dev $TINC multipath on
done
