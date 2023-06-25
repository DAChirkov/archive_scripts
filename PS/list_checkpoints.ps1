$date = Get-Date -format "MM-dd-yyyy"
$days = 30
$log = "...\list_checkpoints_log.txt"
$res = ''

$servers = @('')


#############################
Start-Transcript $log

Write-Host "LIST CHECKPOINTS OLDER THEN" $days "DAYS"
Write-Host ""
Write-Host "----------------------------------------------------------------------------------------------------------"

Import-Module Hyper-V -RequiredVersion 1.1

foreach ($i in $servers)
  {
    Write-Host "$i"
    Write-Host "----------------------------------------------------------------------------------------------------------"
            Get-VM -ComputerName $i | Get-VMSnapshot | Where-Object {$_.CreationTime -lt (Get-Date).AddDays(-$days)} | ft -Property @{ e='CreationTime'; width = 25 },Name -GroupBy VMName -HideTableHeaders
    Write-Host "----------------------------------------------------------------------------------------------------------"
  }

Stop-Transcript
#############################

(Get-Content $log | Select-Object -Skip 19) | Set-Content $log
Start-Sleep 10

#SEND MAIL
$SMTPServer = ""
$Emailfrom = ""
$EmailTo = ""
$Emaillog = Get-Content "...\list_checkpoints_log.txt" | Out-String
$EmailSubject = "HYPER-V checkpoints older then: " + $days + " days. Report on: " + $date

Send-MailMessage -SmtpServer $SMTPServer -To $EmailTo -From $Emailfrom -Subject $EmailSubject -Body $Emaillog