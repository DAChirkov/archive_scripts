$env:PGPASSWORD=''
$catalog="C:\Program Files\PostgreSQL\11.8-6.1C\bin"
$temp="C:\temp_db"
$tables="pg_default"
$user="postgres"

$namedb=""
$new_namedb="$namedb"+"_TEMP"

#-----------------------------------------------------------------------------------------------------
#Copying the base to disk
Start-Process -FilePath $catalog\pg_dump.exe "--host localhost --username $user -F t --dbname $namedb --file $temp/$namedb.copy" -Wait
#Creating a temporary database on the SQL server
Start-Process -FilePath $catalog\createdb.exe "--host localhost --username $user --tablespace $tables $new_namedb" -Wait
#Restoring a copy to a new base
Start-Process -FilePath $catalog\pg_restore.exe "--host localhost --username $user --dbname $new_namedb $temp/$namedb.tar" -Wait
#DELETING THE COPY FROM THE DISK
Remove-Item $temp\$namedb.copy
#-----------------------------------------------------------------------------------------------------
