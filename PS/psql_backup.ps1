$date = Get-Date -uformat "%d-%m-%Y"
$timebackup = (Get-Date).AddDays(-60)

$env:PGPASSWORD=''
$catalog="C:\Program Files\PostgreSQL\11.8-6.1C\bin"
$temp="C:\temp_db"
$tables="pg_default"
$user="postgres"
$namedb=""
$sharedisk=""
$mailTO=""
$mailFROM=""

STOP-SERVICE "1C:Enterprise 8.3 Server Agent (x86-64)" –Passthru
Start-Sleep 60

Start-Process -FilePath $catalog\pg_dump.exe "--host localhost --username $user -F t --dbname $namedb --file $temp/$namedb1.backup" -Wait
Start-Sleep 60

START-SERVICE "1C:Enterprise 8.3 Server Agent (x86-64)" –Passthru

#-----------------------------------------------------------------------------------------------------
Start-Process "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a -ssw -mx9 -r0 $temp\1C_$date.7z $temp\*.backup" -Wait
Remove-Item $temp\*.backup
net use $sharedisk 'PASS' /USER:'USERNAME'
Move-Item -Path $temp\*.7z –Destination $sharedisk

Get-ChildItem $sharedisk | where {$_.lastwritetime -le $timebackup}| remove-item -recurse
if ((-not (Test-Path -PathType Leaf -Path $temp\*)) -and (Test-Path -PathType Leaf -Path $sharedisk\1C_$date.7z))
   {
      Send-MailMessage -To $mailTO -From $mailFROM -Subject “Backup job - Success” -Body “$date / Backup job - Success” -SmtpServer 'SERVERNAME' -Port 25
   }
 else
   {
      Send-MailMessage -To $mailTO -From $mailFROM -Subject “Backup job - Error” -Body “$date / Backup job - Error” -SmtpServer 'SERVERNAME' -Port 25
   }

net use /DELETE $sharedisk
#-----------------------------------------------------------------------------------------------------