# PowerShell Log File Analyzer

## Description
This project scans log files and creates a CSV report showing ERROR, WARNING, and INFO messages.

## Features
- Reads .log files
- Counts ERROR, WARNING, and INFO entries
- Extracts timestamps using regex
- Creates a CSV report
- Includes scheduled task automation example

## Requirements
- PowerShell
- Git

## How To Run
```powershell
./scripts/LogAnalyzer.ps1

## Sample Output

FileName,Errors,Warnings,Info,MostCommonErr
app1.log,2,1,1,Database connection failed
app2.log,1,0,3,API timeout