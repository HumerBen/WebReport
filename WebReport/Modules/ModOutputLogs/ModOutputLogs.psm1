#
# ModOutputLogs.psm1
#

# Output logs to log file
function Fun_OutputLogs
{
	param($LogMessage)
	$CurentDate=Get-Date -UFormat "%Y-%m-%d"
	$LogPath=".\Logs\$CurentDate.log"
	if (!(Test-Path -Path .\Logs))
	{
		New-Item -Path .\Logs -ItemType Directory | Out-Null
	}
	$CurentTime=Get-Date -UFormat "%H:%M%:%S"
	Out-File -FilePath $LogPath -InputObject "$CurentTime $LogMessage" -Append
}