# ==========================
# INTERACTIVE CONFIGURATION
# ==========================
# Prompt for the script path to execute
$ScriptPath = Read-Host "Enter the full path of the PowerShell script to run"

# Prompt for execution interval (in seconds)
$IntervalSeconds = Read-Host "Enter the execution interval (in seconds)"
$IntervalSeconds = [int]$IntervalSeconds

Write-Host "Launcher started"
Write-Host "Script executed every $IntervalSeconds seconds"
Write-Host "Press Ctrl+C to stop"

# ==========================
# INFINITE LOOP
# ==========================
while ($true) {

    $Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$Now] Executing script..."

    try {
        & $ScriptPath
    }
    catch {
        Write-Host "ERROR: $_"
    }

    Start-Sleep -Seconds $IntervalSeconds
}
