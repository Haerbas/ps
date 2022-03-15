#==================================
#   Section 1: Pseudo Code
#==================================

#Repeat Forever
#   Get the files in the source
#   Get the files in the destination
#
#   For each file in the source
#       Check if file exists in the destination
#           Check if the file in the source is newer than the one in the destination
#               Copy file the destination
#           Do Nothing
#       If the file does not exist in the destination
#           Copy file to destination
#
#   For each file in the destination
#       Check if file exists in the source
#           Remove file from the destination

#==================================
#   Section 2: PoswerShell Code
#==================================

param(
    # Parameter for the Folder
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $sourceFolder,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $destinationFolder
)

if(-not (Test-Path -Path $sourceFolder)){
    Write-Host "The source folder specified is invalid. Source Folder provided: $sourceFolder" -ForegroundColor Red
    return
}

if(-not (Test-Path -Path $destinationFolder)){
    Write-Host "The destination folder specified is invalid. Destination Folder provided: $destinationFolder" -ForegroundColor Red
    return
}

#$sourceFolder = "C:\Users\hrb\PS\Source"
#$destinationFolder = "C:\Users\hrb\PS\Destination"

#Repeat Forever
while($true){
    #   Get the files in the source
    $filesInSource = Get-ChildItem $sourceFolder
    #   Get the files in the destination
    $filesInDestination = Get-ChildItem $destinationFolder

    $filesToCopy = @()
    $filesToRemove = @()

        #   For each file in the source
        foreach ($file in $filesInSource){
            #       Check if file exists in the destination
            $destinationMatch = $filesInDestination | Where-Object {$_.Name -eq $file.Name}
            if($destinationMatch){
            #           Check if the file in the source is newer than the one in the destination
            #if((Get-FileHash -Path $file.FullName).Hash -eq (Get-FileHash -Path $destinationMatch.FullName).Hash)
            if($destinationMatch.LastwriteTime -ne $file.LastWriteTime){
                #               Copy file the destination
                $filesToCopy+=$file
            }
        }else{        
            #       If the file does not exist in the destination
            #           Copy file to destination
             $filesToCopy+=$file
        }
    }
    #   For each file in the destination
    foreach ($file in $filesInSource){
        #       Check if file exists in the source
        $sourceMatch = $filesInSource | Where-Object {$_.Name -eq $file.Name}
        if($sourceMatch){
            #           Remove file from the destination
            $filesToRemove+=$file
        }
    }

    if($filesToCopy){
        for($i = 0; $i -lt $filesToCopy.Count; $i++){
            Copy-Item -Path $filesToCopy[$i].FullName -Destination $destinationFolder -Force
            if($?){
                Write-Host "Successsfully copied $($filesToCopy[$i].FullName) to $destinationFolder" -ForegroundColor Green
            }
            else {
                Write-Host "Failed to copy $($filesToCopy[$i].FullName) to $destinationFolder" -ForegroundColor Red
            }
        }
    }

    if($filesToRemove){
        for($i = 0; $i -lt $filesToRemove.Count; $i++){
            Remove-Item -Path $filesToRemove[$i].FullName -Force
            if($?){
                Write-Host "Successsfully removed $($filesToRemove[$i].FullName)" -ForegroundColor Green
            }
            else {
                Write-Host "Failed to remove $($filesToRemove[$i].FullName)" -ForegroundColor Red
            }
        }
    }
}