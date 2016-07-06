#
# ModInvokeCommand.psm1
#

# Import module OutputLog
Import-Module .\Modules\ModOutputLogs\ModOutputLogs.psm1

# Function Invoke-Command
function Fun_InvokeCommand
{
	param ($Computer, $Credential, $ScriptBlock, $CallFrom)

	try
	{
		$ReturnInvokeCommand=Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock $ScriptBlock -ErrorAction Stop
		$LogMessage="Log from ModInvokeCommand.psm1 $CallFrom 执行Invoke-Command成功，已收集相关数据"
		Fun_OutputLogs $LogMessage
		return $ReturnInvokeCommand
	}
	catch
	{
		$LogMessage="Log from ModInvokeCommand.psm1 $CallFrom 执行Invoke-Command失败，请检查相关配置"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
	}
	return $false
}