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
		$LogMessage="Log from ModInvokeCommand.psm1 $CallFrom ִ��Invoke-Command�ɹ������ռ��������"
		Fun_OutputLogs $LogMessage
		return $ReturnInvokeCommand
	}
	catch
	{
		$LogMessage="Log from ModInvokeCommand.psm1 $CallFrom ִ��Invoke-Commandʧ�ܣ������������"
		Fun_OutputLogs $LogMessage
		$LogMessage=$_.Exception.Message
		Fun_OutputLogs $LogMessage
	}
	return $false
}