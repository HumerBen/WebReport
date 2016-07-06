#
# ModCredential.psm1
#

# Imput module ModOutputLogs
Import-Module $WorkPath\Modules\ModOutputLogs\ModOutputLogs.psm1

# Function credential module, return credential variable where $UserName and $Password are not null, otherwise return $false	
function Fun_Credential
{
	param($UserName, $Password)
	if (($UserName.Length -gt 0) -and ($Password.Length -gt 0))
	{
		try
		{
			$SecurePassword=ConvertTo-SecureString -String $Password -ErrorAction Stop
			$ReturnCredential=New-Object System.Management.Automation.PSCredential($UserName, $SecurePassword) -ErrorAction Stop
			return $ReturnCredential
		}
		catch
		{
			$LogMessage="log from ModCredential.psm1 认证信息失败，请检查输入的用户名密码"
			Fun_OutputLogs $LogMessage
			$LogMessage=$_.Exception.Message
			Fun_OutputLogs $LogMessage
		}
	}
	else
	{
		$LogMessage="log from ModCredential.psm1 认证信息失败，请检查输入的用户名密码"
		Fun_OutputLogs $LogMessage
		return $false
	}
}