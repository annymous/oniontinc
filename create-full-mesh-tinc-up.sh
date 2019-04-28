#!/bin/bash
HOSTNAME=`hostname`
TINCS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $3 }'`
cat ~/host-information.txt | grep -e $HOSTNAME > /tmp/hostlines
for TINC in $TINCS
do
   LINE=`cat /tmp/hostlines | grep -e $TINC`
   SUBNET=`echo $LINE | awk -F "|" '{ print $5 }'`
   HOSTIP=`echo $LINE | awk -F "|" '{ print $2 }'`
   echo '#!/bin/sh' > /etc/tinc/$TINC/tinc-up
   echo '/sbin/ifconfig $INTERFACE 10.101.'$SUBNET'.'$HOSTIP' netmask 255.255.255.0' >> /etc/tinc/$TINC/tinc-up
   chmod -v +x /etc/tinc/$TINC/tinc-up
done
