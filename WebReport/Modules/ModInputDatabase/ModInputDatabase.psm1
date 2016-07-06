
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
		$LogMessage="Log from ModInputDatabase.psm1 Snapin `"SqlServerCmdletSnapin100`" 添加失败，请安装Sql Server `"管理工具`(Management Tools`)`"中的powershell组件"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
		return $false
	}

	try
	{
		Invoke-Sqlcmd -Query $Query -ServerInstance $ServerInstance -Username $UserName -Password $Password -ErrorAction Stop
		$LogMessage="Log from ModInputDatabase.psm1 $CallFrom 数据写入成功"
		Fun_OutputLogs $LogMessage
	}
	catch
	{
		$LogMessage="Log from ModInputDatabase.psm1 Invoke-Sqlcmd 语句执行失败，请检查Sql Server"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
		return $false
	}
}