#
# ModOutputLogs.psm1
#

# Output logs to log file
function Fun_OutputLogs
{
	param($LogMessage)
	$CurentDate=Get-Date -UFormat "%Y-%m-%d"
	$LogPath="$WorkPath\Logs\$CurentDate.log"
	if (!(Test-Path -Path $WorkPath\Logs))
	{
		New-Item -Path $WorkPath\Logs -ItemType Directory | Out-Null
	}
	$CurentTime=Get-Date -UFormat "%H:%M%:%S"
	Out-File -FilePath $LogPath -InputObject "$CurentTime $LogMessage" -Append
}