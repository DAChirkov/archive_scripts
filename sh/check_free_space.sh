#!/bin/bash

#Alarm triggering
POROG_ALARM=000
#Checking disk space
DISK_SQL=$(df -h | grep sdb1 | awk '{print $5}' | sed 's/%/0/g')
#Email
ALERT_ADDRESS= #enter email for notification
#Subject
ALERT_SUBJECT_A="WARNING! Available space less than 20%"

if [ $DISK_SQL -ge $POROG_ALARM ] ; then

   df -h | mail -s "$ALERT_SUBJECT_A" $ALERT_ADDRESS

fi