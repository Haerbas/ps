function Send-ToRemoteComputer {
    param (
       [string]$File,
       [string]$DestinationFolder,
       [Parameter(Mandatory=$true)]
       [int]
       $ComputerName
    )
    try {
    
    $session = New-PSSession -ComputerName $ComputerName -ErrorAction Stop
    Copy-Item -Path $File -Destination $DestinationFolder -ToSession $session
    $session | Remove-PSSession

    }
    catch [System.Management.Automation.Remoting.PSRemotingTransportException] {
    Write-Host "There was a problem connecting to Computer: $ComputerName"
    }
}
Send-ToRemoteComputer
return
Send-ToRemoteComputer -file "MyFile1.txt" -destinationFolder C:\temp -ComputerName "Computer1"
Send-ToRemoteComputer -file "MyFile2.txt" -destinationFolder C:\temp -ComputerName "Computer2"
Send-ToRemoteComputer -file "MyFile3.txt" -destinationFolder C:\temp -ComputerName "Computer3"
Send-ToRemoteComputer -file "MyFile4.txt" -destinationFolder C:\temp -ComputerName "Computer4"