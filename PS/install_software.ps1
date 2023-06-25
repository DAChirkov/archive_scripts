######################
$servers = @("")
$sourcefile = ""

foreach ($sourceserver in $servers) {
	$destinationfolder = "\\$sourceserver\'path'"

	if (!(Test-Path -path $destinationFolder\'software_package')) {
		New-Item $destinationfolder -Type Directory;
        Copy-Item -Path $sourcefile -Destination $destinationfolder
	}
}

Invoke-Command -ComputerName $servers -ScriptBlock {
  Start-Process msiexec.exe -wait -ArgumentList '' 

 Remove-Item -Path 'software_package' -Recurse}
######################