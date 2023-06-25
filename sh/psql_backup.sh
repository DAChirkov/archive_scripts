#!/bin/bash
PGPASSFILE=~/.pgpass
USERNAME=postgres

email= #enter email for notification
temp1= #enter the path to the first part of the bases
temp2= #enter the path to the second part of the bases
tempc= #enter the path to the claster configuration
backuplog= #enter the path to the log files
nas= #enter the path to the NAS
fdate="`date +%d-%m-%Y`"
fyear="`date +%Y`"

#1st part of the bases:
bases_1='Base_1-1 Base_1-2 ...' 
#2nd part of the bases:
bases_2='Base_2-1 Base_2-2 ...'

echo "`date +"%Y-%m-%d_%H-%M-%S"`" >> $backuplog/$fdate
echo "" >> $backuplog/$fdate
echo "---------------------------------------------------------------------------------" >> $backuplog/$fdate

#BACKUP
#-----------------------------------------------------------------------------------------------------
#Create in the temporary folder folders with the current date:
mkdir -p # for example - '/home/logs/backup'
mkdir -p $temp1/$fdate
mkdir -p $temp2/$fdate
mkdir -p # for example - '/mnt/backup_temp/cluster'

#Cluster backup:
echo "`date +"%Y-%m-%d_%H-%M-%S"` RUNNING BACKUP CLUSTER" >> $backuplog/$fdate
pg_dumpall -g -U $USERNAME -w  2>> $backuplog/$fdate | pigz > $tempc/cluster_$fdate.sql.gz
echo "`date +"%Y-%m-%d_%H-%M-%S"` BACKUP OF THE CLUSTER HAS BEEN COMPLETED" >> $backuplog/$fdate
echo "---" >> $backuplog/$fdate

#Backup of Part 1 databases:
echo "`date +"%Y-%m-%d_%H-%M-%S"` RUNNING BACKUP BASES" >> $backuplog/$fdate
for base_name1 in $bases_1
do
pg_dump -U  $USERNAME -w $base_name1 2>> $backuplog/$fdate | pigz > $temp1/$fdate/$base_name1.sql.gz
done

tar -czpf $temp1/1st_$fdate.tar.gz $temp1/$fdate 2>> $backuplog/$fdate
rm -Rfd $temp1/$fdate

#Backup of Part 2 databases:
for base_name2 in $bases_2
do
pg_dump -U  $USERNAME -w $base_name2 2>> $backuplog/$fdate | pigz > $temp2/$fdate/$base_name2.sql.gz
done

tar -czpf $temp2/2nd_$fdate.tar.gz $temp2/$fdate 2>> $backuplog/$fdate
rm -Rfd $temp2/$fdate

echo "`date +"%Y-%m-%d_%H-%M-%S"` BACKUP OF THE DATABASES HAS BEEN COMPLETED" >> $backuplog/$fdate
echo "---" >> $backuplog/$fdate

#COPYING ARCHIVES TO THE REPOSITORY
#-----------------------------------------------------------------------------------------------------
#Mounting a network folder:
if ! mountpoint -q # for example - '/mnt/backup' 
then
   mount -t nfs 'server name':/volume1/Backup /mnt/backup/
fi

#Moving archives to the repository
mv $tempc/* $nas/cluster 2>> $backuplog/$fdate
mv $temp1/* $nas/1st 2>> $backuplog/$fdate
mv $temp2/* $nas/2nd 2>> $backuplog/$fdate

#Delete backups older than 90 days (30 day for cluster)
find $nas/cluster/* -mtime +30 -exec rm {} \;
find $nas/1st/* -mtime +90 -exec rm {} \;
find $nas/2nd/* -mtime +90 -exec rm {} \;

#Deleting logs older than 30 days
find $backuplog/* -mtime +30 -exec rm {} \;

echo "---" >> $backuplog/$fdate
echo "`date +"%Y-%m-%d_%H-%M-%S"` BACKUP HAS BEEN COMPLETED" >> $backuplog/$fdate
echo "---------------------------------------------------------------------------------" >> $backuplog/$fdate

sleep 5
mail -s "Backup Report" $email < $backuplog/$fdate