#Variables/Arrays for the Source in line 43
$frn = @(30000,25000,60000,24000)
$frd = @(1000,1200,1001,1000)
$name = @("Bild","Eingabe","4K","Simple")
$image = @("C:\temp\test\Image1_1080.png","C:\temp\test\Image2_720.png","C:\temp\test\Image1_2160.png","C:\temp\test\Image2_1080.png")
#compression rate for encoding
$var = 25

#remote Settings
Enable-PSRemoting
Set-Location "c:\temp\test"
#Because of no Domain Join available, TrustedHosts is necessary
Set-Item WSMan:\localhost\Client\TrustedHosts -value "*" -Force

#Check if Processes are running BRIDGE-Host Instance
$session = New-PSSession -ComputerName 10.0.1.20 -ConfigurationName NDI -ErrorAction Stop
Invoke-Command -Session $session -ScriptBlock { 


if(!(Get-Process | Where-Object { $_.ProcessName -eq "Application.NDI.VPN.UI" }))
{
    Start-process "C:\Program Files\NDI\NDI 5 Tools\Bridge\Application.NDI.VPN.UI.exe" /host -WindowStyle Normal
}
if(!(Get-Process | Where-Object { $_.ProcessName -eq "Application.Network.StudioMonitor.x64" }))
{
    Start-process "C:\Program Files\NDI\NDI 5 Tools\Studio Monitor\Application.Network.StudioMonitor.x64.exe" -WindowStyle Normal
}

#NDI-Host ConfigSettings - set the value for compression (EncoderQuality)
$filename = "C:\Users\Administrator\AppData\Local\NDI\NDI_Bridge\ndi_bridge_vpn.ndibridge"
[regex]$pattern='"Quality":\d+'
$pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$Using:var",1) | set-content $filename
}

#Check if Process is running on the BRIDGE-Join Instance
$session1 = New-PSSession -ComputerName 10.0.2.10 -ConfigurationName NDI -ErrorAction Stop
Invoke-Command -Session $session1 -ScriptBlock {

if(!(Get-Process | Where-Object { $_.ProcessName -eq "Application.NDI.VPN.UI" }))
{
    Start-process "C:\Program Files\NDI\NDI 5 Tools\Bridge\Application.NDI.VPN.UI.exe" /join -WindowStyle Normal
}}


#for loop with different input sources, each executed once, as defined above in the arrays
for ($i = 0; $i -lt $frn.count; $i++){
Start NDIlib_Send_PNG.x64.exe "/frn:$($frn[$i]) /frd:$($frd[$i]) /name:$($name[$i]) /image:$($image[$i])"
#Only a hint for information
Write-Output "/frn:$($frn[$i]) /frd:$($frd[$i]) /name:$($name[$i]) /image:$($image[$i])"

#Invoke Analysis.exe at Analyze-NDI and store values in analysis.txt
Invoke-Command -ComputerName 10.0.2.20 -ConfigurationName NDI -ScriptBlock {& "C:\Program Files\NDI\NDI 5 Analysis BETA\x64\NDIAnalysis.exe" /find > "c:\temp\analysis.txt"; 
#modify analysis.txt and pick up the desired sources (in this case, i take all with EC2AMAZ and remote REMOTE called sources)
Select-String -Path c:\temp\analysis.txt -Pattern "EC2AMAZ-" | where {$_.Line -notlike "*Remote*"} | foreach {($_.Line)} | Out-String > c:\temp\string.txt; 
#final step is to read the content of string.txt and remove the rest of content - split '='
$file = get-content "c:\temp\string.txt"
$file | foreach { $source = $_ -split '=' ; $newfile = $source[1] | out-file -Append C:\temp\source.txt } 
$newsource = get-content C:\temp\source.txt
#These variables are used to query the instance type on AWS, where the Tag is Bridge-Host
$Instance = get-ec2tag | Where-Object {$_.Value -like "Bridge-Host*" -and $_.ResourceType -eq "instance"}
$InstType = (get-ec2instance).RunningInstance | Where-Object { $_.InstanceId -eq $Instance.ResourceId }
[string]$Type = ($InstType).InstanceType
#creating a folder on analyze instance
$path = "c:\temp\$Type-Logs"
#check if folder exist
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
#Save the Output in CSV
foreach ($x in $newsource){& "C:\Program Files\NDI\NDI 5 Analysis BETA\x64\NDIAnalysis.exe" /source:$x /csv:$path\$Type-$(get-date -Format "MMddyy.HHmmss")-$x-$Using:var%.csv /time:10 }
Remove-Item c:\temp\*.txt -force
#Remove-Item $path\*ANALYZE*.csv
#Remove-item $path\*Connection*.csv
#Creating a Bucket and upload content if doesn't exist
[string]$BucketName = "vizrtmeasurelogs"
if (!(Test-S3Bucket -BucketName ($BucketName)))
{
    New-S3Bucket -BucketName $BucketName -Region eu-central-1
}
Write-S3Object -BucketName $BucketName -Folder $path -KeyPrefix $Type-Different-Sources
}
Start-Sleep -Seconds 5
get-Process | ? {$_.ProcessName -like "*NDIlib*"} | Stop-Process -Force
}


#for loop with same input sources, executed from starting 1 source up to 15 sources 1080p30
for ($i = 0; $i -lt 3; $i++){
    Start NDIlib_Send_PNG.x64.exe "/frn:30000 /frd:1000 /name:TestImage$i /image:C:\temp\test\Image2_1080.png"
    $v = $i
    #same as above
    Invoke-Command -ComputerName 10.0.2.20 -ConfigurationName NDI -ScriptBlock {& "C:\Program Files\NDI\NDI 5 Analysis BETA\x64\NDIAnalysis.exe" /find > "c:\temp\analysis.txt"; 
    
    Select-String -Path c:\temp\analysis.txt -Pattern "EC2AMAZ-JOIN","EC2AMAZ-BRIDGE-HOST" | where {$_.Line -notlike "*Remote*"} | foreach {($_.Line)} | Out-String > c:\temp\string.txt; 
    
    $file = get-content "c:\temp\string.txt"
    $file | foreach { $source = $_ -split '=' ; $newfile = $source[1] | out-file -Append C:\temp\source.txt } 
    $newsource = get-content C:\temp\source.txt
 
    $Instance = get-ec2tag | Where-Object {$_.Value -like "Bridge-Host*" -and $_.ResourceType -eq "instance"}
    $InstType = (get-ec2instance).RunningInstance | Where-Object { $_.InstanceId -eq $Instance.ResourceId }
    [string]$Type = ($InstType).InstanceType
    $path = "c:\temp\$Type-$Using:v-Run"
    If(!(test-path $path))
    {
          New-Item -ItemType Directory -Force -Path $path
    }
    #Save the Output in CSV
    
    foreach ($x in $newsource){& "C:\Program Files\NDI\NDI 5 Analysis BETA\x64\NDIAnalysis.exe" /source:$x /csv:$path\$Type-$(get-date -Format "MMddyy.HHmmss")-$x-$Using:var%.csv /time:10 }
    Remove-Item c:\temp\*.txt -force

    #Part for create a Bucket and upload content
    [string]$BucketName = "vizrtmeasurelogs"
    if (!(Test-S3Bucket -BucketName ($BucketName)))
    {
        New-S3Bucket -BucketName $BucketName -Region eu-central-1
    }
    #here i divide the simulation into different directories so that there is a clean separation after it's generated from an array, it starts at 0 instead of 1!
    Write-S3Object -BucketName $BucketName -Folder $path -KeyPrefix $Type-$Using:v-Sources
    }
}
get-Process | ? {$_.ProcessName -like "*NDIlib*"} | Stop-Process -Force

exit