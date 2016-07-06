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
	# ѡ�����蹦��
	Write-Host "`n  ��ѡ����Ҫ���õ�ģ�飺 `n  1������`"1`" ����SQL Server  `n  2������`"2`" ����DDC  `n  3������`"3`"����AD `n  4������`"4`"��`"Q`" �˳�`n"

	# �ж�ѡ����
	$InputCmd=Read-Host "  ������"

	if ($InputCmd -eq "1")
	{
		Clear-Host
		Fun_Sql
		Clear-Host
		Read-Host "  Sql Server������ɣ�[���س����ص����˵�]"
		Fun_Main
	}
	elseif ($InputCmd -eq "2")
	{
		Clear-Host
		Fun_DDC
		Clear-Host
		Read-Host "  DDC ������ɣ�[���س����ص����˵�]"
		Fun_Main
	}
	elseif ($InputCmd -eq "3")
	{
		Clear-Host
		Fun_AD
		Clear-Host
		Read-Host "  AD ������ɣ�[���س����ص����˵�]"
		Fun_Main
	}
	elseif (($InputCmd.ToUpper() -eq "Q") -or ($InputCmd -eq "4"))
	{
		Clear-Host
		Write-Host "`n  �˳�����..."
		Exit
	}
	else
	{
		Clear-Host
		Read-Host "`n  �������������ѡ��,[���س�����]"
		Fun_Main
	}
}

# Function input plain text
function Fun_InputPlainText
{
	param($ShowMessage)
	# Get plain text from user
	Write-Host "  ������$ShowMessage"
	do
	{
		$Flag=$true
		$ReturnPlainText=Read-Host "  ������"
		if ([string]::IsNullOrEmpty($ReturnPlainText))
		{
			Clear-Host
			Write-Host -ForegroundColor Red "  ���벻��Ϊ�գ�����������$ShowMessage"
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
	Write-Host "  ������$ShowMessage"
	do
	{
		$Flag=$true
		try
		{
			[securestring]$InputSecureString=Read-Host "  ������" -AsSecureString
			$ReturnSecureString=ConvertFrom-SecureString $InputSecureString
		}
		catch
		{
			$Flag=$false
			Clear-Host
			Write-Host -ForegroundColor Red "  ���벻��Ϊ�գ�����������$ShowMessage"
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
	$Message="SQL Server ��������ʵ���� [ComputerName\InstanceName]"
	$SqlServerInstance=Fun_InputPlainText $Message

	# Set sa as sql server administrator user
	$SqlUser="sa"

	Clear-Host
	# Get sql server "sa" password
	$Message="SQL Server `"sa`"�û�����"
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
	$Message="DDC ��������IP��ַ"
	$DDCComputerName=Fun_InputPlainText $Message

	Clear-Host
	# Get DDC username
	$Message="DDC �û���"
	$DDCUserName=Fun_InputPlainText $Message

	Clear-Host
	# Get DDC password
	$Message="DDC �û�����"
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
	$Message="AD ��������IP��ַ"
	$ADComputerName=Fun_InputPlainText $Message

	Clear-Host
	# Get AD username
	$Message="AD �û���"
	$ADUserName=Fun_InputPlainText $Message

	Clear-Host
	# Get AD password
	$Message="DDC �û�����"
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