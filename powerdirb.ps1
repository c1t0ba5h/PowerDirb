try {
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

    Write-Host $asciiArt -ForegroundColor Cyan
    Write-Host "`n[-] Launching PowerDirb Scan..." -ForegroundColor Green
    Write-Host "----------------------------------------------------" -ForegroundColor Green
    Start-Sleep -Seconds 1

    $target = Read-Host "[-] What is your target (include: http:// or https://)?"
    $wordlistInput = Read-Host "[-] Provide local wordlist file path or a hosted wordlist URL"
    $ext = Read-Host "[-] What extension do you want to use (example: .pdf - leave blank for none)?"
    $session = Read-Host "[-] Enter your cookie (leave blank if not applicable)"
    $authToken = Read-Host "[-] Enter your Authorization token (leave blank if not applicable)"
    $outputFile = Read-Host "[-] Enter output file path (e.g., results.txt)"
    
    Write-Host "`nResults:" -ForegroundColor Green
    Write-Host "----------------------------------------------------" -ForegroundColor Green
    
    $headers = @{}
    if (-not [string]::IsNullOrWhiteSpace($session)) {
        $headers.Add('Cookie', $session)
    }
    if (-not [string]::IsNullOrWhiteSpace($authToken)) {
        $headers.Add('Authorization', $authToken)
    }
    
    $wordlist = @()
    if (Test-Path $wordlistInput) {
        Write-Host "[-] Reading wordlist from local file..." -ForegroundColor Yellow
        $wordlist = Get-Content $wordlistInput
    } elseif ($wordlistInput -like "http*") {
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
    
    foreach ($dir in $wordlist) {
        $dir = $dir.Trim()
        if (-not [string]::IsNullOrWhiteSpace($dir)) {
            $full = "$target/$dir$ext"
            try {
                $response = Invoke-WebRequest -Uri $full -Method Get -Headers $headers -ErrorAction Stop -MaximumRedirection 0
                $headerSize = ($response.Headers | Out-String).Length
                $contentSize = $response.Content.Length
                $totalSize = $headerSize + $contentSize
                
                $color = switch ([int]$response.StatusCode) {
                    200 { "Green" }
                    405 { "DarkYellow" }
                    403 { "Red" }
                    { $_ -ge 300 -and $_ -lt 400 } { "Blue" }
                    Default { "White" }
                }
                
                $output = "Found: $full -- (SIZE: $totalSize bytes | response code: $($response.StatusCode))"
                Write-Host $output -ForegroundColor $color
                Add-Content -Path $outputFile -Value $output
            } catch {
                if ($_.Exception.Response -and $_.Exception.Response.StatusCode -eq 403) {
                    $output = "Forbidden: $full (response code: 403)"
                    Write-Host $output -ForegroundColor Red
                    Add-Content -Path $outputFile -Value $output
                } elseif ($_.Exception.Response -and $_.Exception.Response.StatusCode -ge 300 -and $_.Exception.Response.StatusCode -lt 400) {
                    $redirectResponse = $_.Exception.Response
                    $location = $redirectResponse.Headers["Location"]
                    $output = "Redirect: $full -> $location (response code: $($redirectResponse.StatusCode))"
                    Write-Host $output -ForegroundColor Blue
                    Add-Content -Path $outputFile -Value $output
                } else {
                    continue
                }
            }
        }
    }
} finally {
    $currentTime = Get-Date
    Write-Host "----------------------------------------------------" -ForegroundColor Green
    Write-Host "`nFinished Scan at: $currentTime" -ForegroundColor Green
    Add-Content -Path $outputFile -Value "----------------------------------------------------"
    Add-Content -Path $outputFile -Value "Finished Scan at: $currentTime"
}
