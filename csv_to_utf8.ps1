# Powershell Scritp to automatically set all folder files enconding to utf8

$InPath = 'F:\IN'
$OutPath = 'F:\OUT'

try {

    if (Test-Path -Path $OutPath) {
        "OutPath exists!"
        $directoryInfo = Get-ChildItem $OutPath | Measure-Object

        if ($directoryInfo.count -eq 0) {
            "OutPath is empty"
        }
        Else {
            "OutPath is not empty"
            "Deleting files"
            Get-ChildItem -Path $OutPath -Include *.* -File -Recurse | foreach { $_.Delete() }
            #exit
        }
        
    }
    else {
        "Creating OutPath"
        New-Item -ItemType "directory" -Path $OutPath
    }

    Write-Output "Starting encoding & EOL conversion to UTF8 & CRLF in path: $InPath "
	
    $a = Get-ChildItem -Path $InPath -Filter *.csv
    ForEach ($item in $a) {
        Get-Content $item.FullName | Set-Content  -Encoding ASCII "$($item.Basename)_new.csv"  
    }
	
    Write-Output "Finished Converting files"
	
    foreach ($item in (Get-ChildItem -Path $InPath | Where-Object Extension -in ('.csv'))) {

        If ($item.LastWriteTime -lt ((Get-Date).AddDays(-1))) {

        }
        Else {
            Move-Item $item.FullName $OutPath
        }
    }

    Write-Output "Finished moving files to InPath"


    Get-ChildItem $OutPath  | Rename-Item -NewName { $_.name -replace '_new', '' }

    Write-Output "Finished renaming new files"
	
}

catch {
    Write-Error $_.Exception.ToString()
    Read-Host -Prompt "The above error occurred. Press Enter to exit."
}