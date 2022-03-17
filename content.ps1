#With this approch, a content of a file will read, then the place what should be exchanged is running, and all of it 4 times with foreach
$count=@(1;2;3;4)

foreach($c in $count){
    $var
    $filename = "C:\Users\hrb\AppData\Local\NDI\NDI_Bridge\ndi_bridge_vpn.ndibridge"
    switch($var){
        25 {[regex]$pattern='"Quality":\d+'
        $pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$var",1) | set-content $filename-her25
        $var = $var + 25}
        50 {[regex]$pattern='"Quality":\d+'
        $pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$var",1) | set-content $filename-her50
        $var = $var + 50}
        100 {[regex]$pattern='"Quality":\d+'
        $pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$var",1) | set-content $filename-her100
        $var = $var + 50}
        150 {[regex]$pattern='"Quality":\d+'
        $pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$var",1) | set-content $filename-her150
        $var = 25}
        default {"No Value" $var = 25}
    }
}

#same approach like above, instead of switch with if and elseif else
$count=@(1;2;3;4)

foreach($c in $count){
    $var
    $filename = "C:\Users\hrb\AppData\Local\NDI\NDI_Bridge\ndi_bridge_vpn.ndibridge"
    if($var -eq 25){
    [regex]$pattern='"Quality":\d+'
    $pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$var",1) | set-content $filename-her25
    $var = $var + 25
    }elseif ($var -eq 50) {
    [regex]$pattern='"Quality":\d+'
    $pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$var",1) | set-content $filename-her50
    $var = $var + 50
    }elseif($var -eq 100) {
    [regex]$pattern='"Quality":\d+'
    $pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$var",1) | set-content $filename-her100
    $var = $var + 50
    }elseif($var -eq 150) {
    [regex]$pattern='"Quality":\d+'
    $pattern.replace([IO.File]::ReadAllText($filename),"`"Quality`":$var",1) | set-content $filename-her150
    $var = 25
    }else{
        return
    }}