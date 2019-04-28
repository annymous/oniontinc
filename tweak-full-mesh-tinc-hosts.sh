#!/bin/bash
HOSTNAME=`hostname`
cat ~/host-information.txt | grep -e $HOSTNAME > /tmp/hostlines
TINCHOSTS=`cat /tmp/hostlines | awk -F "|" '{ print $4 }'`
for TINCHOST in $TINCHOSTS
do
   LINE=`cat /tmp/hostlines | grep -e $TINCHOST`
   SOCKSPORT=`echo $LINE | awk -F "|" '{ print $8 }'`
   TINCPORT=`echo $LINE | awk -F "|" '{ print $9 }'`
   TINCONION=`echo $LINE | awk -F "|" '{ print $10 }'`
   HOSTNO=`echo $LINE | awk -F "|" '{ print $2 }'`
   TINC=`echo $LINE | awk -F "|" '{ print $3 }'`
   SNET=`echo $LINE | awk -F "|" '{ print $5 }'`
   echo 'Address = '$TINCONION > /tmp/$TINCHOST
   echo 'TCPOnly = yes' >> /tmp/$TINCHOST
   echo 'Proxy = socks5 127.0.0.1 '$SOCKSPORT >> /tmp/$TINCHOST
   echo 'Subnet = 10.101.'$SNET'.'$HOSTNO'/32' >> /tmp/$TINCHOST
   echo 'Port = '$TINCPORT >> /tmp/$TINCHOST
   cat /etc/tinc/$TINC/hosts/$TINCHOST >> /tmp/$TINCHOST
   cat /tmp/$TINCHOST > /etc/tinc/$TINC/hosts/$TINCHOST
done
