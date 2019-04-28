#!/bin/bash

HOSTNAME=`hostname`
TORS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $6 }'`
for TOR in $TORS
do
   LINE=`cat ~/host-information.txt | grep -e $HOSTNAME | grep -e $TOR`
   TINC=`echo $LINE | awk -F "|" '{ print $3 }'`
   TORRC=`echo $LINE | awk -F "|" '{ print $7 }'`
   SOCKSPORT=`echo $LINE | awk -F "|" '{ print $8 }'`
   TINCPORT=`echo $LINE | awk -F "|" '{ print $9 }'`
   mkdir /var/lib/$TOR
   chown debian-tor:debian-tor /var/lib/$TOR
   echo 'SocksPort 127.0.0.1:'$SOCKSPORT > /etc/tor/$TORRC
   echo 'SocksPolicy accept 127.0.0.1' >> /etc/tor/$TORRC
   echo 'SocksPolicy reject *' >> /etc/tor/$TORRC
   echo 'VirtualAddrNetwork 10.192.0.0/10' >> /etc/tor/$TORRC
   echo 'AutomapHostsOnResolve 1' >> /etc/tor/$TORRC
   echo 'Log notice file /var/log/tor/notices-'$TOR'.log' >> /etc/tor/$TORRC
   echo 'RunAsDaemon 1' >> /etc/tor/$TORRC
   echo 'DataDirectory /var/lib/'$TOR >> /etc/tor/$TORRC
   echo 'HiddenServiceDir /var/lib/'$TOR'/'$TINC'/' >> /etc/tor/$TORRC
   echo 'HiddenServiceVersion 3' >> /etc/tor/$TORRC
   echo 'HiddenServicePort '$TINCPORT' 127.0.0.1:'$TINCPORT >> /etc/tor/$TORRC
done
