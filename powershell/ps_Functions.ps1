# Setup Logging
function _setuplogging()
{
$LogTime = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
$LogPath = "C:\Logs\"
if([IO.Directory]::Exists($LogPath))
{
}
else
{
New-Item -ItemType directory -Path $LogPath
}
}

# Event Handling - Write to console, and log file, and make it pretty
# Valid types: info, success, error
function _prettylog($eventstring, $type)
{
$LogFile = $LogPath + "\PowerShell.log"
if ($type -eq $null -or $type -eq "info")
{
Write-Host INFO: $eventstring -foregroundcolor white
$LogTime + "- INFO:" + $eventstring | out-file $LogFile -append
}
elseif ($type -eq "success")
{
Write-Host SUCCESS: $eventstring -foregroundcolor green
$LogTime + "- SUCCESS:" + $eventstring | out-file $LogFile -append
}
elseif ($type -eq "error")
{
Write-Host ERROR: $eventstring -foregroundcolor red -backgroundcolor black
$LogTime + "- ERROR:" + $eventstring | out-file $LogFile -append
}
}