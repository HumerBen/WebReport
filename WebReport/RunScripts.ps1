#
# RunScripts.ps1
#

# Import modules
Import-Module .\Modules\ModOutputLogs\ModOutputLogs.psm1



# Function run specify script
function Fun_RunScript
{
	param ($StopTime, $TimeSpan, $ScriptPath)
	do
	{
		# Get now again and again
		$Now=Get-Date
		Start-Sleep $TimeSpan
		try
		{
			powershell.exe $ScriptPath
		}
		catch
		{
			$LogMessage="Log from RunScripts.ps1 Ö´ÐÐ $ScriptPath ³ö´í"
			Fun_OutputLogs $LogMessage
		}
	}
	until ($Now.ToString() -eq $StopTime.ToString())
}


# ------ Main ------

# Set current time plus 10 hours as stop time
[datetime]$StopTime=(Get-Date).AddHours(10)

# Set timespan
$TimeSpan=900

# Run GetCitrixDDCInformation.ps1
$ScriptPath=".\GetCitrixDDCInformation.ps1"
Fun_RunScript $StopTime $TimeSpan $ScriptPath
