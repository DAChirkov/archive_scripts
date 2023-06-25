$os = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x64)’
$path = ""
$pathinstall=""

$list = "" 

if ($os) 
 {$os="x64"}
else  
 {$os="x86"}

if (-not (Test-Path -Path $pathinstall))
   {New-Item -ItemType directory -Path $pathinstall
    $folder = Get-ItemProperty -Path $pathinstall
    $folder | Get-Member
    $folder.Attributes = "Hidden"}

foreach ($kb in $list)
{
 if (Test-Path -PathType Leaf -Path "$pathinstall\$kb.txt")
    {Continue}
   else
    {
      if (Get-HotFix $kb)
         {New-Item -Name "$kb.txt" -Path $pathinstall -ItemType File}       
        else
         {dism.exe /Online /Add-Package /PackagePath:$path\Windows6.1-$kb-$os.cab /Quiet /NoRestart | Out-Null}

            if (Get-HotFix $kb)
               {New-Item -Name "$kb.txt" -Path $pathinstall -ItemType File}
              else
               {New-Item -Name "$kb.error_install.txt" -Path $pathinstall -ItemType File}
    }    
}