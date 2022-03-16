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