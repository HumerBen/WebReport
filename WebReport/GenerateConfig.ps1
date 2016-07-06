#
# GenerateConfig.ps1
#

# Import output config modules
Import-Module $WorkPath\Modules\ModOutputConfig\ModOutputConfig.psm1

# Function Main
function Fun_Main
{
	# Clear screen
	Clear-Host
	# 选择所需功能
	Write-Host "`n  请选择需要配置的模块： `n  1、输入`"1`" 配置SQL Server  `n  2、输入`"2`" 配置DDC  `n  3、输入`"3`"配置AD `n  4、输入`"4`"或`"Q`" 退出`n"

	# 判断选择结果
	$InputCmd=Read-Host "  请输入"

	if ($InputCmd -eq "1")
	{
		Clear-Host
		Fun_Sql
		Clear-Host
		Read-Host "  Sql Server配置完成，[按回车键回到主菜单]"
		Fun_Main
	}
	elseif ($InputCmd -eq "2")
	{
		Clear-Host
		Fun_DDC
		Clear-Host
		Read-Host "  DDC 配置完成，[按回车键回到主菜单]"
		Fun_Main
	}
	elseif ($InputCmd -eq "3")
	{
		Clear-Host
		Fun_AD
		Clear-Host
		Read-Host "  AD 配置完成，[按回车键回到主菜单]"
		Fun_Main
	}
	elseif (($InputCmd.ToUpper() -eq "Q") -or ($InputCmd -eq "4"))
	{
		Clear-Host
		Write-Host "`n  退出程序..."
		Exit
	}
	else
	{
		Clear-Host
		Read-Host "`n  输入错误，请重新选择,[按回车继续]"
		Fun_Main
	}
}

# Function input plain text
function Fun_InputPlainText
{
	param($ShowMessage)
	# Get plain text from user
	Write-Host "  请输入$ShowMessage"
	do
	{
		$Flag=$true
		$ReturnPlainText=Read-Host "  请输入"
		if ([string]::IsNullOrEmpty($ReturnPlainText))
		{
			Clear-Host
			Write-Host -ForegroundColor Red "  输入不能为空，请重新输入$ShowMessage"
			$Flag=$false
		}	
	}
	until ($Flag)
	return $ReturnPlainText
}

# Function input secure string
function Fun_InputSecureString
{
	param($ShowMessage)
	# Get secure string
	Write-Host "  请输入$ShowMessage"
	do
	{
		$Flag=$true
		try
		{
			[securestring]$InputSecureString=Read-Host "  请输入" -AsSecureString
			$ReturnSecureString=ConvertFrom-SecureString $InputSecureString
		}
		catch
		{
			$Flag=$false
			Clear-Host
			Write-Host -ForegroundColor Red "  输入不能为空，请重新输入$ShowMessage"
		}
	}
	until ($Flag)
	return $ReturnSecureString
}


# Function Sql
function Fun_Sql
{
	Clear-Host
	# Get sql server instance
	$Message="SQL Server 主机名和实例名 [ComputerName\InstanceName]"
	$SqlServerInstance=Fun_InputPlainText $Message

	# Set sa as sql server administrator user
	$SqlUser="sa"

	Clear-Host
	# Get sql server "sa" password
	$Message="SQL Server `"sa`"用户密码"
	$SaPassword=Fun_InputSecureString $Message

	$ComputerNameKey="SqlServerIntance"
	$UserNameKey="SqlUserName"
	$PasswordKey="SqlPassword"

	# Output to config file
	Fun_OutputConfig $ComputerNameKey $SqlServerInstance $UserNameKey $SqlUser $PasswordKey $SaPassword

}

# Function DDC
function Fun_DDC
{
	Clear-Host
	# Get DDC ComputerName
	$Message="DDC 主机名或IP地址"
	$DDCComputerName=Fun_InputPlainText $Message

	Clear-Host
	# Get DDC username
	$Message="DDC 用户名"
	$DDCUserName=Fun_InputPlainText $Message

	Clear-Host
	# Get DDC password
	$Message="DDC 用户密码"
	$DDCPassword=Fun_InputSecureString $Message

	$ComputerNameKey="DDCComputerName"
	$UserNameKey="DDCUserName"
	$PasswordKey="DDCPassword"

	# Output to config file
	Fun_OutputConfig $ComputerNameKey $DDCComputerName $UserNameKey $DDCUserName $PasswordKey $DDCPassword
}

# Function AD
function Fun_AD
{
	Clear-Host
	# Get AD ComputerName
	$Message="AD 主机名或IP地址"
	$ADComputerName=Fun_InputPlainText $Message

	Clear-Host
	# Get AD username
	$Message="AD 用户名"
	$ADUserName=Fun_InputPlainText $Message

	Clear-Host
	# Get AD password
	$Message="DDC 用户密码"
	$ADPassword=Fun_InputSecureString $Message

	$ComputerNameKey="ADComputerName"
	$UserNameKey="ADUserName"
	$PasswordKey="ADPassword"

	# Output to config file
	Fun_OutputConfig $ComputerNameKey $ADComputerName $UserNameKey $ADUserName $PasswordKey $ADPassword
}


# Start program 
Fun_Main
Exit