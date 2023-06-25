#!/bin/sh
PGPASSFILE=~/.pgpass
USERNAME=postgres

temp=""
namedb=""
base_sql="$namedb"_TEMP""
tables="db_workplace"

#-----------------------------------------------------------------------------------------------------
mkdir $temp

pg_dump -U $USERNAME -w $namedb > $temp/$namedb.sql
createdb --username $USERNAME -w --tablespace $tables -T template0 $base_sql
psql -U $USERNAME -w $base_sql < $temp/$namedb.sql
rm -f $temp/$namedb.sql

#-----------------------------------------------------------------------------------------------------

