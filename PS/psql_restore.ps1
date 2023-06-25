$date = "" #enter date for restore
$namedb="" #enter db name for restore

$user=""
$env:PGPASSWORD=''
$catalog="C:\Program Files\PostgreSQL\11.8-6.1C\bin"
$tables="pg_default"
$temp="C:\temp_db"
$new_namedb="$namedb"+"_TEMP"
$sharedisk=""

net use $sharedisk 'PASS' /USER:'USERNAME'
Copy-Item -Path $sharedisk\1C_$date.7z -Destination $temp 
net use /DELETE $sharedisk

Start-Process "C:\Program Files\7-Zip\7z.exe" -ArgumentList "e $temp\1C_$date.7z -o$temp $namedb.backup" -Wait
Start-Process -FilePath $catalog\createdb.exe "--host localhost --username $user --tablespace $tables $new_namedb" -Wait
Start-Process -FilePath $catalog\pg_restore.exe "--host localhost --username $user --dbname $new_namedb $temp/$namedb.backup" -Wait

Remove-Item $temp\1C_$date.7z
Remove-Item $temp\$namedb.backup