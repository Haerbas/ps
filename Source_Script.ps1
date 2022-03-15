Set-Location -Path "C:\temp\test"
$frn = @(30000,25000)
$frd = @(1000,1200)
$name = @("Bild","Eingabe")
$image = @("C:\temp\test\Image1_1080.png","C:\temp\test\Image2_720.png")
for ($i = 0; $i -lt $frn.count; $i++){
start NDIlib_Send_PNG.x64.exe "/frn:$($frn[$i]) /frd:$($frd[$i]) /name:$($name[$i]) /image:$($image[$i])"
#Write-Output "Das ist die [$i].Ausgabe!" $frn[$i] $frd[$i] $name[$i] $image[$i]
Invoke-Command -ComputerName 10.0.2.20 -ScriptBlock {& "C:\Program Files\NDI\NDI 5 Analysis BETA\x64\NDIAnalysis.exe" /find > "c:\temp\hakan.txt"; 
Select-String -Path c:\temp\hakan.txt -Pattern "EC2AMAZ-SOURCE" | foreach {($_.Line)} | Out-String > c:\temp\string.txt; 
$file = get-content "c:\temp\string.txt"
$file | foreach { $source = $_ -split '=' ; $newfile = $source[1] | out-file -Append C:\temp\source.txt} 
$newsource = get-content C:\temp\source.txt
foreach ($x in $newsource){& "C:\Program Files\NDI\NDI 5 Analysis BETA\x64\NDIAnalysis.exe" /source:$x /csv:C:\temp\$x.$(get-date -Format "MMddyyyy.HHmmss").csv /time:10}
Write-Output "Das ist " $newsource.Length }
}
Start-Sleep -Seconds 5
get-Process | ? {$_.ProcessName -like "*NDIlib*"} | Stop-Process -Force

#Set-Item WSMan:\localhost\Client\TrustedHosts -value 10.0.2.20
#get-item WSMan:\localhost\Client\TrustedHosts