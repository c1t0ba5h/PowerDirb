# PowerDirb ASCII Art with UFO Design
$asciiArt = @"
         ____   _____   ____  
        |    | |  _  | |    |  
    ____|____|_|_|_|_|_|____|____
   /                            \
  /  PowerDirb: Directory Buster  \
 /________________________________\
            ________________
          //                \\
         //==================\\
        ||   .-.      .-.     ||
       _||  / o \    / o \    ||_
      /=||  \   /____\   /    ||=\
     |  ||===\__________/=====||  |
      \_||____________________||_/
        ||____________________||
        | \      |   |      / |
       /   \_____|___|_____/   \
      /_________________________\
     /    Scanning Directories    \
    /         from Above!          \
    \_____________________________/
          ( )               ( )
       ( (   ) )         ( (   ) )
      ( ) ( ) ( )       ( ) ( ) ( )
         (_)                 (_)
                          -by c1t0 
"@

# Print the ASCII Art to the terminal
Write-Host $asciiArt -ForegroundColor Cyan

# Add a pause to keep the console open
Write-Host "`n Launching PowerDirb Scan..." -ForegroundColor Green
Start-Sleep -Seconds 2  # Simulate some process

$target = Read-Host " What is your target?"
$url = Read-Host " What is list do you want to use?"



    # Fetch the content from the external server
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing

    # Split the content by newlines to create an array of words
    $wordList = $response.Content -split "`r?`n"

    # Iterate over each word in the list
    foreach ($word in $wordList) {
        if (-not [string]::IsNullOrWhiteSpace($word)) {
            # Build the full URL
            $full = $target + "/" + $word
    
            try {
                # Send the web request inside the try block
                $response = Invoke-WebRequest -Uri $full -Method Get -ErrorAction Stop
    
                # Only print the URL if the status code is 200 or 405
                if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 405 -or $response.StatusCode -eq 302) {
                    if ($response.StatusCode -eq 200) {
                        Write-Host "Found: $full -- response code: 200" -ForegroundColor Green
                    } elseif ($response.StatusCode -eq 405) {
                        Write-Host "Found: $full -- response code: 405" -ForegroundColor DarkYellow  # Close to orange
                    } elseif ($response.StatusCode -eq 302) {
                        Write-Host "Found: $full -- response code: 405" -ForegroundColor Blue  
                    }
                }
            } catch {
                # Silently ignore any errors
                continue
            }
        }
    }
