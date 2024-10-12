try {
    # PowerDirb ASCII Art with UFO Design
    $asciiArt = @"
         ____   _____   ____  
        |    | |  _  | |    |  
    ____|____|_|_|_|_|_|____|____
   /                            \
  /  PowerDirb: Directory Buster \
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
     /    Scanning Directories   \
    /         from Above!         \
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
    Write-Host "`nLaunching PowerDirb Scan..." -ForegroundColor Green
    Start-Sleep -Seconds 1  # Sleep for one second for style.

    # Get target and wordlist URL
    $target = Read-Host "What is your target?" 
    $url = Read-Host "Where is your wordlist?"
    $ext = Read-Host "What extension do you want to use (example: .pdf - leave blank for none)?"
    Write-Host "`nResults:" -ForegroundColor Green
    Write-Host "----------------------------------------------------" -ForegroundColor Green

    # Attempt to fetch the wordlist
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
        $wordList = $response.Content -split "`r?`n"
    } catch {
        Write-Host "Could not retrieve the wordlist: $($_.Exception.Message)" -ForegroundColor Red
        return  # Exit the script if wordlist retrieval fails
    }

    # Iterate over each word in the list
    foreach ($word in $wordList) {
        if (-not [string]::IsNullOrWhiteSpace($word)) {
            $full = "$target/$word$ext"
            # Make the web request if the response is 200/405/302, print them with different colors
            try {
                $response = Invoke-WebRequest -Uri $full -Method Get -ErrorAction Stop

                if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 405 -or $response.StatusCode -eq 302) {
                    $color = switch ($response.StatusCode) {
                        200 { "Green" }
                        405 { "DarkYellow" }
                        302 { "Blue" }
                    }
                    $size = $response.Content.Length
                    
                    Write-Host "Found: $full -- (SIZE: $size | response code: $($response.StatusCode))" -ForegroundColor $color
                }
            } catch {
                # Don't print 404s or other errors to screen
                continue
            }
        }
    }
} finally {
    # This block will always run, even if errors occur
    $currentTime = Get-Date
    Write-Host "----------------------------------------------------" -ForegroundColor Green
    Write-Host "`nFinished Scan at: $currentTime" -ForegroundColor Green
}