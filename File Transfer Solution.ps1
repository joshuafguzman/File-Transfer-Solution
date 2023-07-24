$servers = ""  # Replace with your actual server addresses

$source = ""  # Replace with the actual folder you want to copy

$destination = "" # Replace with your actual backup location

 

# Function to recursively copy files and subfolders

function Copy-FilesRecursively($sourceFolder, $destinationFolder){

    # Retrieve all files in the current folder

    $files = Get-ChildItem -Path $sourceFolder -File

    foreach ($file in $files) {

        $destinationFile = Join-Path -Path $destinationFolder -ChildPath $file.Name

        if (-not (Test-Path $destinationFile)) {

            $file | Copy-Item -Destination $destinationFolder

            Write-Host "Copied file $file"

        }

        else {

            Write-Host "File $file already exists at $destinationFolder, not copied"

        }

    }

   

    # Retrieve all subfolders in the current folder

    $subfolders = Get-ChildItem -Path $sourceFolder -Directory

    foreach ($subfolder in $subfolders) {

        $newDestinationFolder = Join-Path -Path $destinationFolder -ChildPath $subfolder.Name

        if (-not (Test-Path $newDestinationFolder)) {

            New-Item -ItemType Directory -Path $newDestinationFolder | Out-Null

        }

                                else {

            Write-Host "Subfolder $subfolder already exists at $destinationFolder, not created"

        }

        # Recursively call the function for each subfolder

        Copy-FilesRecursively $subfolder.FullName $newDestinationFolder

    }

               

    # Display a message when all files and subfolders within the current folder are copied

    Write-Host "All files and subfolders in $sourceFolder have been copied."

 

}

 

# Loop indefinitely

while ($true) {

    # Try to ping each server

    $connected = $false

    foreach ($server in $servers) {

        if (Test-Connection $server -Quiet -Count 1) {

            Write-Host "Connected to $server"

            $connected = $true

            break

        }

    }

   

    if ($connected) {

        # If ping successful, copy files and subfolders recursively

        Copy-FilesRecursively $source $destination

    } else {

        Write-Host "Not connected"

    }

   

    # Wait for 10 minutes before checking again

    Start-Sleep -Seconds 600

}