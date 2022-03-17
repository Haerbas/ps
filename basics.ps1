Get-ADUser -Identity "hrb" -Properties proxyAddresses | ft -Wrap -AutoSize
Get-Command -Name Get-Team
Find-Module -Name *Team*
Get-Module -Name MicrosoftTeams -ListAvailable
Install-Module -Name MicrosoftTeams -Scope CurrentUser
Connect-MicrosoftTeams
get-team | Sort-Object name

Test-Connection 127.0.0.1 | ft -Wrap -AutoSize

get-childitem

$Variable = "Test"

Write-Host $Variable -ForegroundColor Green

get-location

Get-Process
get-help Start-Process -Examples
((get-volume)[0]).SizeRemaining

$colours = @()
$colours += "black"
$colours += "white"
$colours += "green"
$colours += "blue"
$colours += "purple"
$colours += "dark"

$colours.count

for ($i = 0; $i -le $colours.Length; $i++){write-host "Das sind hier die Werte: " $colours[$i]}

get-help if -Examples

do
{
$i = 0
write-host = "Das sind hier die Werte $colours[$colours]"
$i++
}while ($i -le $colours.Length)

foreach ($color in $colours)
{ write-host "Das ist hier der Wert $color"}


$proc = Get-Process

$proc.length

for ($i=0; $i -le $proc.Length; $i++)
{
write-host "Prozesse: " $proc[$i]
}

[int]$var=Read-Host "Bitte gebe eine Zahl ein"

if ($var -eq 34234)
{
write-host "die Zahl ist $var" -ForegroundColor Cyan
}
else
{
write-host "ich weiß es nicht!" -ForegroundColor DarkGreen
}

Get-Location

set-location -Path C:\Users\hrb\Downloads
Get-ChildItem -Path *.txt | ? {$_.Length -gt 80} | Sort-Object -Property Length -Descending | Select-Object Name, Length

new-item -ItemType File -Name "IchbineinFile.txt"
get-childitem | Sort-Object -Property LastWriteTime





Get-ChildItem | ForEach-Object { $_ } | Where-Object | 

get-help Where-Object -Examples


get-help Get-ItemPropertyValue

Update-Help -UICulture de-DE

Get-Module -ListAvailable | Where-Object {$_.CompatiblePSEditions -eq "Core"}

Find-Module -Name "*Azure*" | get-command add-aaduser

writhe-host "Hallo $env:APPDATA"

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Get-Host
$PSVersionTable.PSVersion

if (condition) {
    
}else {
    
}


#read content from file, replace it with the method and write it back
$content = [System.IO.File]::ReadAllText("C:\Users\hrb\AppData\Local\NDI\NDI_Bridge\ndi_bridge_vpn.ndibridge").Replace("Quality","25",1)
[System.IO.File]::WriteAllText("c:\bla.txt", $content)