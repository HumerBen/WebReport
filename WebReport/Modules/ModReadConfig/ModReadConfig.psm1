#
# ModReadConfig.psm1
#

# Import module ModOutputLogs
Import-Module .\Modules\ModOutputLogs\ModOutputLogs.psm1

# Function read config
function Fun_ReadConfig
{
	param($StringKey)
	$ReturnValue=""
	try
	{
		$ConfigContent=Get-Content .\Config -ErrorAction Stop
	}
	catch
	{
		$LogMessage="Log from ModReadConfig.psm1 �����ļ������쳣������Config�ļ�"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
	}
	
	foreach($ConfigLine in $ConfigContent)
	{
		if ($ConfigLine.Contains($StringKey))
		{
			$ReturnValue=$ConfigLine.Substring($ConfigLine.IndexOf("=")+1)
			# Return Value after "="
			return $ReturnValue
		}
	}

	# If $StringKey not exsit then return false
	return $false
}