#!/bin/bash
HOSTNAME=`hostname`
TINCS=`cat ~/host-information.txt | grep -e $HOSTNAME | awk -F "|" '{ print $3 }'`
for TINC in $TINCS
do
   echo '#!/bin/sh' > /etc/tinc/$TINC/tinc-down
   echo '/sbin/ifconfig $INTERFACE down' >> /etc/tinc/$TINC/tinc-down
   chmod -v +x /etc/tinc/$TINC/tinc-down
done
