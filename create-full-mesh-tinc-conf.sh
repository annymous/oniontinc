#!/bin/bash
HOSTNAME=`hostname`
TINCS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $3 }'`
for TINC in $TINCS
do
   LINE=`cat ~/host-information.txt | grep -e $HOSTNAME | grep -e $TINC`
   TINCHOST=`echo $LINE | awk -F "|" '{ print $4 }'`
   TINCPORT=`echo $LINE | awk -F "|" '{ print $9 }'`
   mkdir -p /etc/tinc/$TINC/hosts/
   echo 'Name = '$TINCHOST > /etc/tinc/$TINC/tinc.conf
   echo 'Device = /dev/net/tun' >> /etc/tinc/$TINC/tinc.conf
   cat ~/host-information.txt | grep -v $HOSTNAME | grep -v "TINCHOST" > /tmp/peerlines
   PEERS=`cat /tmp/peerlines | awk -F "|" '{ print $4 }'`
   for PEER in $PEERS
   do
      echo 'ConnectTo = '$PEER >> /etc/tinc/$TINC/tinc.conf
   done
   echo 'BindToAddress = 127.0.0.1' >> /etc/tinc/$TINC/tinc.conf
   echo 'AddressFamily = ipv4' >> /etc/tinc/$TINC/tinc.conf
   echo 'Port = '$TINCPORT >> /etc/tinc/$TINC/tinc.conf
done
