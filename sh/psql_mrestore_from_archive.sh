#!/bin/bash
PGPASSFILE=~/.pgpass
USERNAME=postgres

tempdir=""
temptype="TEMP"

#Mounting a network folder:
if mountpoint -q /mnt/backup.
then
else
   mount -t 'server name':/volume1/Backup /mnt/backup/
fi

namedb=""
datedb="" #08-04-2021
typedb="" #1st or 2nd

base_sql="${namedb}_TEMP"
copy_arch="${typedb}_${datedb}"
tables="db_workplace"

#-----------------------------------------------------------------------------------------------------
cp /mnt/backup/$typedb/$copy_arch.tar.gz $tempdir/$temptype
tar -xvf $tempdir/$temptype/$copy_arch.tar.gz -C /$tempdir/$temptype
rm -f $tempdir/$temptype/$copy_arch.tar.gz

cp $tempdir/$temptype/$tempdir/$typedb/$datedb/$namedb.sql.gz $tempdir/$temptype
rm c -r $tempdir/$temptype/mnt

unpigz $tempdir/$temptype/$namedb.sql.gz 
 
createdb --username $USERNAME -w --tablespace $tables -T template0 $base_sql
psql -U $USERNAME -w $base_sql < $tempdir/$temptype/$namedb.sql
rm -f $tempdir/$temptype/$namedb.sql
#-----------------------------------------------------------------------------------------------------

