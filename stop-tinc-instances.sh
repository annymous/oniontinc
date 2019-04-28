#!/bin/bash
PIDS=`ps -lC tincd | awk '{ print $4 }' | grep -v PID`
for PID in $PIDS
do
   kill $PID
done
