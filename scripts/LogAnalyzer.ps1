param(
    [string]$LogFolder = "./logs",
    [string]$OutputFile = "./reports/summary_report.csv"
)

# Create reports folder if missing
if (!(Test-Path "./reports")) {
    New-Item -ItemType Directory -Path "./reports"
}

# Function to analyze log files
function Analyze-LogFile {

    param(
        [string]$FilePath
    )

    Write-Host "Analyzing $FilePath"

    $errorCount = 0
    $warningCount = 0
    $infoCount = 0

    $errorMessages = @()

    Get-Content $FilePath | ForEach-Object {

        $line = $_

        # Extract timestamp
        if ($line -match '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}') {
            $timestamp = $matches[0]
        }

        # Count log levels
        if ($line -match 'ERROR') {
            $errorCount++
            $errorMessages += $line
        }
        elseif ($line -match 'WARNING') {
            $warningCount++
        }
        elseif ($line -match 'INFO') {
            $infoCount++
        }
    }

    # Find most common error
    $topError = $errorMessages |
        Group-Object |
        Sort-Object Count -Descending |
        Select-Object -First 1

    # Return custom object
    [PSCustomObject]@{
        FileName      = Split-Path $FilePath -Leaf
        Errors        = $errorCount
        Warnings      = $warningCount
        Info          = $infoCount
        MostCommonErr = if ($topError) { $topError.Name } else { "None" }
    }
}

# Analyze all log files
$results = @()

Get-ChildItem -Path $LogFolder -Filter *.log | ForEach-Object {
    $results += Analyze-LogFile -FilePath $_.FullName
}

# Export report
$results | Export-Csv -Path $OutputFile -NoTypeInformation

Write-Host "Report saved to $OutputFile"