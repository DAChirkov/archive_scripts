$un=${env:UserName}

Get-ChildItem "C:\Users\$un\AppData\Local\1C\1Cv8\*", "C:\Users\$un\AppData\Roaming\1C\1Cv8\*" `
| Where {$_.Name -as [guid]} |Remove-Item -Force -Recurse