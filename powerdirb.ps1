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
    Write-Host "`n[-] Launching PowerDirb Scan..." -ForegroundColor Green
    Start-Sleep -Seconds 1  # Sleep for one second for style.

    # Get target and wordlist URL
    $target = Read-Host "[-] What is your target?" 
    $url = Read-Host "[-] Where is your wordlist?"
    $ext = Read-Host "[-] What extension do you want to use (example: .pdf - leave blank for none)?"
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
            
            try {
                # Make the web request with -MaximumRedirection 0 to prevent automatic redirection
                $response = Invoke-WebRequest -Uri $full -Method Get -ErrorAction Stop -MaximumRedirection 0

                # Calculate response size (headers + content)
                $headerSize = ($response.Headers | Out-String).Length
                $contentSize = $response.Content.Length
                $totalSize = $headerSize + $contentSize

                # Determine the color based on the status code
                $color = switch ($response.StatusCode) {
                    200 { "Green" }
                    405 { "DarkYellow" }
                    { $_ -ge 300 -and $_ -lt 400 } { "Blue" }  # Handles all 3xx redirects
                    Default { "White" }
                }

                # Write the result to the console
                Write-Host "Found: $full -- (SIZE: $totalSize bytes | response code: $($response.StatusCode))" -ForegroundColor $color

            } catch {
                # Handle redirection exceptions explicitly
                if ($_.Exception.Response -and $_.Exception.Response.StatusCode -ge 300 -and $_.Exception.Response.StatusCode -lt 400) {
                    $redirectResponse = $_.Exception.Response

                    # Extract the Location header if it exists (for redirects)
                    $location = $redirectResponse.Headers["Location"]

                    # Output the redirection information to the console
                    Write-Host "Redirect: $full -> $location (response code: $($redirectResponse.StatusCode))" -ForegroundColor Blue
                } else {
                    # Continue silently for other errors (like 404)
                    continue
                }
            }
        }
    }
} finally {
    # This block will always run, even if errors occur
    $currentTime = Get-Date
    Write-Host "----------------------------------------------------" -ForegroundColor Green
    Write-Host "`nFinished Scan at: $currentTime" -ForegroundColor Green
}