Get-Process | Measure-Object WS -Sum -Maximum -Minimum -Average #(Measure-Command listet die Anzahl)

Get-WinEvent -LogName security -MaxEvents 5 #(Listet die Eventlogs von Security auf, Max die ersten 5 Einträge)

Invoke-Command -ComputerName Computer1, Computer2 -ScriptBlock { Get-WinEvent -LogName security -MaxEvents 5 } #(Führt einen Remote commannd auf die gewünschten Server mit Einsicht in die Eventlogs - 5 Einträge)

Get-NetAdapter | Where-Object { $_.Name -like "Ethernet*" } | Enable-NetAdapter #(Listet Netzwerkkarten auf, die den Namen Ether beinhalten und aktiviert diese)

$procs = Get-Process
$procc2 = Get-Process
Compare-Object -ReferenceObject $procs -DifferenceObject $procc2 -Property Name #(compare two varibles eachother)


#####Remote
Get-Service -Name "WinRM"

get-command -Noun *Psremoting*

Get-PSSessionConfiguration

Invoke-Command -ComputerName 3.72.106.40 { $env:computername } #get the name of the remote-host

Invoke-command -ComputerName 3.72.106.40 -ScriptBlock { Get-EventLog -LogName security } | Select-Object -First 10 #Bad command, because of taking of to many compute resource
Invoke-command -ComputerName 3.72.106.40 -ScriptBlock { Get-EventLog -LogName security | Select-Object -First 10 } #would be better, because the resource is placed on the remote site
Invoke-command -ComputerName 3.72.106.40 -ScriptBlock { Get-EventLog -LogName security -newest 10 } #would be more efficient
Invoke-command -ComputerName 3.72.106.40 -ScriptBlock { Get-Process }
Measure-Command { Invoke-command -ComputerName 3.72.106.40 -ScriptBlock { Get-Process } | Where-Object { $_.name -eq "notepad" } } #this is measuring the time of the command to run! very nice!!!

#Remote Session (Means the session is persistent)

New-PSSession -ComputerName ServerA #Creates a Session on that machine
Enter-PSSession -ComputerName ServerA #Take the remote session
Remove-PSSession -ComputerName ServerA #deletes session

$psess = New-PSSession -ComputerName ServerA 
Import-Module ActiveDirectory -PSSession $psess   #with this command, you can import "implicitly" modules from the machine, where the modules are installed. Instead of "cmdlets" this are only "functions" and with get-modules they appear as "script" instead of "manifest"

Install-Module Windowscompatibility -Scope CurrentUser #installs the module which allows then to import older version of cmdlets

Import-Module Microsoft.PowerShell.Management #activate older versions like "get-eventlog"