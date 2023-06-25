#!/bin/bash
PGPASSFILE=~/.pgpass
USERNAME=postgres
temp=""
fdate="`date -d "1 day" +%d-%m-%Y`"
ftime="`date +%H-%M`"

namedb=""
typedb="" #1st or 2nd

base_sql="${namedb}_manual_${ftime}"
#-----------------------------------------------------------------------------------------------------
mkdir -p $temp/$typedb/$fdate
pg_dump -U $USERNAME -w $namedb | pigz > $temp/$typedb/$fdate/$base_sql.sql.gz
#-----------------------------------------------------------------------------------------------------