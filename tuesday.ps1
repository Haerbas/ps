#generate Input Sources with this Parameters
$frn = @(30000,25000)
$frd = @(1000,1200)
$name = @("Bild","Eingabe")
$image = @("C:\temp\test\Image1_1080.png","C:\temp\test\Image2_720.png")

Enable-PSRemoting
Set-Location "c:\temp\test"
#Start Remote Call to the Analyze computer and set the Client as TrustedHosts
Set-Item WSMan:\localhost\Client\TrustedHosts -value "*" -Force
Invoke-Command -ComputerName 10.0.1.20 -ScriptBlock {
if(!(Get-Process | Where-Object { $_.ProcessName -like "*StudioMonitor*" }))
{
    Start-process "C:\Program Files\NDI\NDI 5 Tools\Studio Monitor\Application.Network.StudioMonitor.x64.exe"
}}

#Run Command as length of the Array
for ($i = 0; $i -lt $frn.count; $i++){
start NDIlib_Send_PNG.x64.exe "/frn:$($frn[$i]) /frd:$($frd[$i]) /name:$($name[$i]) /image:$($image[$i])"
#First Command looks for the Sources and saves it in a file
Invoke-Command -ComputerName 10.0.2.20 -ScriptBlock {& "C:\Program Files\NDI\NDI 5 Analysis BETA\x64\NDIAnalysis.exe" /find > "c:\temp\hakan.txt"; 
#Second Command takes only the necessary part with source name, and saves it into a file
Select-String -Path c:\temp\hakan.txt -Pattern "EC2AMAZ-SOURCE" | foreach {($_.Line)} | Out-String > c:\temp\string.txt; 
#Reading File content and format/split it in the desired form and save it also in a file
$file = get-content "c:\temp\string.txt"
$file | foreach { $source = $_ -split '=' ; $newfile = $source[1] | out-file -Append C:\temp\source.txt } 
$newsource = get-content C:\temp\source.txt
#These Variables are for the Instance Type running on AWS, where the Tag has Bridge-Host
$Instance = get-ec2tag | Where-Object {$_.Value -like "Bridge-Host*" -and $_.ResourceType -eq "instance"}
$InstType = (get-ec2instance).RunningInstance | Where-Object { $_.InstanceId -eq $Instance.ResourceId }
[string]$Type = ($InstType).InstanceType
$path = "c:\temp\$Type-Logs"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
#Foreach as the value of the sources
foreach ($x in $newsource){& "C:\Program Files\NDI\NDI 5 Analysis BETA\x64\NDIAnalysis.exe" /source:$x /csv:$path\$Type-$(get-date -Format "MMddyy.HHmmss")-$x.csv /time:10 }
}
Start-Sleep -Seconds 5
get-Process | ? {$_.ProcessName -like "*NDIlib*"} | Stop-Process -Force
}


Invoke-Command -ComputerName 10.0.2.20 -ScriptBlock {

#These Variables are for the Instance Type running on AWS, where the Tag has Bridge-Host
$Instance = get-ec2tag | Where-Object {$_.Value -like "Bridge-Host*" -and $_.ResourceType -eq "instance"}
$InstType = (get-ec2instance).RunningInstance | Where-Object { $_.InstanceId -eq $Instance.ResourceId }
[string]$Type = ($InstType).InstanceType
$path = "c:\temp\$Type-Logs"

#Part for create a Bucket and upload content
[string]$BucketName = "vizrtmeasurelogs"
if (!(Test-S3Bucket -BucketName ($BucketName)))
{
    New-S3Bucket -BucketName $BucketName -Region eu-central-1
}
Write-S3Object -BucketName $BucketName -Folder $path -KeyPrefix $Type
}

#Set-Item WSMan:\localhost\Client\TrustedHosts -value 10.0.2.20
#get-item WSMan:\localhost\Client\TrustedHosts