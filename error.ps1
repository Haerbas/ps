try {
    #$FilesInE = Get-ChildItem E:\ -ErrorAction Stop
    Remove-Item C:\temp\noteafile.csv -ErrorAction Stop
}
catch [system.management.automation.drivenotfoundexception] {
    Write-Host "The drive E was not found! Sorry, failed" -ForegroundColor Red
}
catch [system.management.automation.itemnotfoundexception] {
    Write-Host "this is another error" -ForegroundColor Cyan
}