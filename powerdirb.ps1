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

    Write-Host "`n[-] Launching PowerDirb Scan..." -ForegroundColor Green
    Write-Host "----------------------------------------------------" -ForegroundColor Green
    Start-Sleep -Seconds 1  # Sleep for style

    # Get target, wordlist file or URL, and other inputs
    $target = Read-Host "[-] What is your target (include: http:// or https://)?"
    $wordlistInput = Read-Host "[-] Provide local wordlist file path or a hosted wordlist URL"
    $ext = Read-Host "[-] What extension do you want to use (example: .pdf - leave blank for none)?"
    $session = Read-Host "[-] Enter your cookie (leave blank if not applicable)"
    $authToken = Read-Host "[-] Enter your Authorization token (leave blank if not applicable)"
    Write-Host "`nResults:" -ForegroundColor Green
    Write-Host "----------------------------------------------------" -ForegroundColor Green

    # Set headers based on provided input
    $headers = @{}
    if (-not [string]::IsNullOrWhiteSpace($session)) {
        $headers.Add('Cookie', $session)
    }
    if (-not [string]::IsNullOrWhiteSpace($authToken)) {
        $headers.Add('Authorization', $authToken)
    }

    # Read wordlist based on local file or URL
    $wordlist = @()
    if (Test-Path $wordlistInput) {
        # If it's a local file
        Write-Host "[-] Reading wordlist from local file..." -ForegroundColor Yellow
        $wordlist = Get-Content $wordlistInput
    } elseif ($wordlistInput -like "http*") {
        # If it's a URL
        Write-Host "[-] Downloading wordlist from URL..." -ForegroundColor Yellow
        try {
            $wordlistContent = Invoke-WebRequest -Uri $wordlistInput -UseBasicParsing
            $wordlist = $wordlistContent.Content -split "`n"
        } catch {
            Write-Host "[-] Failed to download wordlist from URL." -ForegroundColor Red
            exit
        }
    } else {
        Write-Host "[-] Invalid input. Please provide either a valid file path or a URL." -ForegroundColor Red
        exit
    }

    # Iterate through the wordlist
    foreach ($dir in $wordlist) {
        $dir = $dir.Trim()
        if (-not [string]::IsNullOrWhiteSpace($dir)) {
            $full = "$target/$dir$ext"
            try {
                $response = Invoke-WebRequest -Uri $full -Method Get -Headers $headers -ErrorAction Stop -MaximumRedirection 0

                # Calculate response size (headers + content)
                $headerSize = ($response.Headers | Out-String).Length
                $contentSize = $response.Content.Length
                $totalSize = $headerSize + $contentSize

                # Determine the color based on the status code
                $color = switch ([int]$response.StatusCode) {
                    200 { "Green" }
                    405 { "DarkYellow" }
                    403 { "Red" }
                    { $_ -ge 300 -and $_ -lt 400 } { "Blue" }
                    Default { "White" }
                }

                # Output the result
                Write-Host "Found: $full -- (SIZE: $totalSize bytes | response code: $($response.StatusCode))" -ForegroundColor $color

            } catch {
                if ($_.Exception.Response -and $_.Exception.Response.StatusCode -eq 403) {
                    # Handle 403 Forbidden responses
                    Write-Host "Forbidden: $full (response code: 403)" -ForegroundColor Red
                } elseif ($_.Exception.Response -and $_.Exception.Response.StatusCode -ge 300 -and $_.Exception.Response.StatusCode -lt 400) {
                    # Handle redirects
                    $redirectResponse = $_.Exception.Response
                    $location = $redirectResponse.Headers["Location"]
                    Write-Host "Redirect: $full -> $location (response code: $($redirectResponse.StatusCode))" -ForegroundColor Blue
                } else {
                    # Continue silently for other errors
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