<#
.SYNOPSIS
    Jira Sprint Copilot - PowerShell CLI Runner
.DESCRIPTION
    Native Windows execution wrapper for Jira Sprint Copilot.
.EXAMPLE
    .\scripts\copilot.ps1 triage
    .\scripts\copilot.ps1 inspect --board-id 1001 --sprint-id 2002
    .\scripts\copilot.ps1 suggest --issue-keys ENG-101 --apply --approved-by "Alex Rivera"
#>

[CmdletBinding()]
param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$ScriptArgs
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
$PythonCli = Join-Path $RootDir "copilot.py"

# Locate Python interpreter
$PythonBin = $null
if (Get-Command "python" -ErrorAction SilentlyContinue) {
    $PythonBin = "python"
} elseif (Get-Command "py" -ErrorAction SilentlyContinue) {
    $PythonBin = "py"
} elseif (Get-Command "python3" -ErrorAction SilentlyContinue) {
    $PythonBin = "python3"
} else {
    Write-Error "Python 3.8+ is required but was not found in PATH."
    exit 1
}

& $PythonBin $PythonCli @ScriptArgs
exit $LASTEXITCODE
