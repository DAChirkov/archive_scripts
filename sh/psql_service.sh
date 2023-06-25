#!/bin/sh
PGPASSFILE=~/.pgpass
USERNAME=postgres

email= #enter email for notification
backuplog= #enter the path to the part of the logs
fdate="`date +%d-%m-%Y`"

echo "`date +"%Y-%m-%d_%H-%M-%S"`" >> $backuplog/$fdate
echo "" >> $backuplog/$fdate
echo "---------------------------------------------------------------------------------" >> $backuplog/$fdate

#1st part of the bases:
bases_1='Base_1-1 Base_1-2 ...' 
#2nd part of the bases:
bases_2='Base_2-1 Base_2-2 ...'

#DATABASE MAINTENANCE
#-----------------------------------------------------------------------------------------------------
#Running the VACUUM
#--------------
echo "`date +"%Y-%m-%d_%H-%M-%S"` Running the VACUUM" >> $backuplog/$fdate

#DB 1st:
#--------------
for base_name1 in $bases_1
do
/usr/bin/vacuumdb --analyze -U $USERNAME -w -d $base_name1 >> $backuplog/$fdate
done

#DB 2nd:
#--------------
for base_name2 in $bases_2
do
/usr/bin/vacuumdb --analyze -U $USERNAME -w -d $base_name2  >> $backuplog/$fdate
done

echo "`date +"%Y-%m-%d_%H-%M-%S"` VACUUM HAS BEEN COMPLETED" >> $backuplog/$fdate
echo "---" >> $backuplog/$fdate

#Running the REINDEX
#--------------
echo "`date +"%Y-%m-%d_%H-%M-%S"` Running the REINDEX" >> $backuplog/$fdate

#DB 1st:
#--------------
for base_name1 in $bases_1
do
/usr/bin/reindexdb -e -U $USERNAME -w -d $base_name1  >> $backuplog/$fdate
done

#DB 2nd:
#--------------
for base_name2 in $bases_2
do
/usr/bin/reindexdb -e -U $USERNAME -w -d $base_name2  >> $backuplog/$fdate
done

#Deleting logs older than 90 days
find $backuplog/* -mtime +90 -exec rm {} \;

echo "`date +"%Y-%m-%d_%H-%M-%S"` REINDEX HAS BEEN COMPLETED" >> $backuplog/$fdate
echo "---------------------------------------------------------------------------------" >> $backuplog/$fdate

sleep 5
mail -s "Service Report" $email < $backuplog/$fdate 