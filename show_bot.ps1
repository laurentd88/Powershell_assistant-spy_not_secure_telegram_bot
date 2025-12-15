# ==========================
# CONFIGURATION INTERACTIVE
# ==========================
# Prompt the user for the Telegram bot token
$BotToken = Read-Host "Enter your Telegram bot token"

# Prompt the user for the offset file path
$OffsetFile = Read-Host "Enter the full path for the offset file"

# Prompt the user for the log file path
$LogFile = Read-Host "Enter the full path for the log file"

# ==========================
# INITIALIZE OFFSET
# ==========================
# Create offset file if it does not exist
if (-not (Test-Path $OffsetFile)) {
    Set-Content $OffsetFile 0
}
$Offset = [int](Get-Content $OffsetFile)

# ==========================
# LOG EXECUTION TIME
# ==========================
$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $LogFile -Value "[$Now] --- Script execution started ---"

# ==========================
# TELEGRAM API CALL
# ==========================
$Url = "https://api.telegram.org/bot$($BotToken)/getUpdates?offset=$Offset"
$response = Invoke-RestMethod -Uri $Url -Method Get

# ==========================
# PROCESS MESSAGES
# ==========================
if ($response.result.Count -eq 0) {
    Add-Content -Path $LogFile -Value "[$Now] No new messages"
} else {
    foreach ($update in $response.result) {
        $msgTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $user = $update.message.from.username
        $text = $update.message.text

        # Log each message with timestamp and username
        Add-Content -Path $LogFile -Value "[$msgTime] @$user: $text"

        # Update offset to avoid reprocessing messages
        $Offset = $update.update_id + 1
    }
