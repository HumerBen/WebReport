#
# ModDDCDataOutputDatabase.psm1
#

# Import modules
Import-Module $WorkPath\Modules\ModReadConfig\ModReadConfig.psm1
Import-Module $WorkPath\Modules\ModOutputLogs\ModOutputLogs.psm1
Import-Module $WorkPath\Modules\ModInputDatabase\ModInputDatabase.psm1

# Output ddc data to Database
function Fun_DDCDataOutputDatabase
{
	param ($Query, $CallFrom)
	# Database serverinstance
	$SQLServerInstanceKey="SqlServerIntance"
	$SQLServerInstance=Fun_ReadConfig $SQLServerInstanceKey

	# Database username
	$SQLUserNameKey="SqlUserName"
	$SQLUserName=Fun_ReadConfig $SQLUserNameKey

	# Database password need to convert to securestring
	$SQLPasswordKey="SqlPassword"
	$SQLEncryptPassword=Fun_ReadConfig $SQLPasswordKey

	try
	{
		$SecureStringSQLPassword=ConvertTo-SecureString -String $SQLEncryptPassword -ErrorAction Stop
	}
	catch
	{
		$LogMessage="Log from GetCitrixDDCInformation 密文转换为安全字符错误 ，请确认配置文件Config是否在本机生成，否则请运行GenerateConfig.ps1重新生成配置文件Config"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
	}

	try
	{
		$SQLPassword=[System.Runtime.InteropServices.Marshal]::PtrToStringUni([System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($SecureStringSQLPassword))
	}
	catch
	{
		$LogMessage="Log from GetCitrixDDCInformation 安全字符转换为明文错误 ，请确认配置文件Config是否在本机生成，否则请运行GenerateConfig.ps1重新生成配置文件Config"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
	}

	# Output DDC data to database 
	Fun_InputDatabase $Query $SQLServerInstance $SQLUserName $SQLPassword $CallFrom
}