for ($i = 0; $i -lt 10; $i++)
{ Write-Host "here we go $i" }

$a = @("test1"; "test2"; 5; "test4"; "test5")

foreach ($sum in $a) {
    write-host "this is $sum"
}

$a | ForEach-Object {
    write-host $_.GetType()
}

Get-ChildItem | ForEach-Object { $_.FullName }
