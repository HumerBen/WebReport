
#
# ModInputDatabase.psm1
#

# Import modules
Import-Module .\Modules\ModReadConfig\ModReadConfig.psm1
Import-Module .\Modules\ModOutputLogs\ModOutputLogs.psm1

# Input data to database
function Fun_InputDatabase
{
	param ($Query, $ServerInstance, $UserName, $Password, $CallFrom)
	
	# Add Pssnapin SqlServerCmdletSnapin100
	try
	{
		Add-PSSnapin SqlServerCmdletSnapin100 -ErrorAction Stop
	}
	catch
	{
		$LogMessage="Log from ModInputDatabase.psm1 Snapin `"SqlServerCmdletSnapin100`" ���ʧ�ܣ��밲װSql Server `"������`(Management Tools`)`"�е�powershell���"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
		return $false
	}

	try
	{
		Invoke-Sqlcmd -Query $Query -ServerInstance $ServerInstance -Username $UserName -Password $Password -ErrorAction Stop
		$LogMessage="Log from ModInputDatabase.psm1 $CallFrom ����д��ɹ�"
		Fun_OutputLogs $LogMessage
	}
	catch
	{
		$LogMessage="Log from ModInputDatabase.psm1 Invoke-Sqlcmd ���ִ��ʧ�ܣ�����Sql Server"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
		return $false
	}
}