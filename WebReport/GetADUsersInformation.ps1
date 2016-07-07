#
# GetADUsersInformation.ps1
#

# Import modules
try
{
	Import-Module .\Modules\ModReadConfig\ModReadConfig.psm1 -ErrorAction Stop
	Import-Module .\Modules\ModOutputLogs\ModOutputLogs.psm1 -ErrorAction Stop
	Import-Module .\Modules\ModCredential\ModCredential.psm1 -ErrorAction Stop
	Import-Module .\Modules\ModInputDatabase\ModInputDatabase.psm1 -ErrorAction Stop
}
catch
{
	Out-File -InputObject "$(Get-Date) from GetADUsersInformation.ps1 Import-Module fail ,check modules" -FilePath .\GetADUsersInformation.log
}

# Starting
$LogMessage="Starting ..."
Fun_OutputLogs $LogMessage

# Get AD computer name
$ADComputerNameKey="ADComputerName"
$ADComputerName=Fun_ReadConfig $ADComputerNameKey

# Get AD credential
$ADUserNameKey="ADUserName"
$ADUserName=Fun_ReadConfig $ADUserNameKey

$ADPasswordKey="ADPassword"
$ADPassword=Fun_ReadConfig $ADPasswordKey

$ADCredential=Fun_Credential $ADUserName $ADPassword

# Database serverinstance
$SQLServerInstanceKey="SqlServerIntance"
$SQLServerInstance=Fun_ReadConfig $SQLServerInstanceKey

# Database username
$SQLUserNameKey="SqlUserName"
$SQLUserName=Fun_ReadConfig $SQLUserNameKey

# Database password need to convert to securestring
$SQLPasswordKey="SqlPassword"
$SQLEncryptPassword=Fun_ReadConfig $SQLPasswordKey

# Call from
$CallFrom="GetADusersInformation"

try
{
	$SecureStringSQLPassword=ConvertTo-SecureString -String $SQLEncryptPassword -ErrorAction Stop
}
catch
{
	$LogMessage="Log from GetADUsersInfomation.ps1 密文转换为安全字符错误 ，请确认配置文件Config是否在本机生成，否则请运行GenerateConfig.ps1重新生成配置文件Config"
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
	$LogMessage="Log from GetADUsersInfomation.ps1 安全字符转换为明文错误 ，请确认配置文件Config是否在本机生成，否则请运行GenerateConfig.ps1重新生成配置文件Config"
	Fun_OutputLogs $LogMessage
	$LogMessage=$_.Exception.Message
	Fun_OutputLogs $LogMessage
}

# Get $ADGetGroups
$ADGetGroupsScriptBlock=
{
	(Import-Module ActiveDirectory) ;
	(Get-ADGroup -Filter {GroupScope -eq "Global"} -SearchBase "OU=Wit,DC=witsoft,DC=cn")
}

try
{
	$ADGroups=Invoke-Command -ComputerName $ADComputerName -Credential $ADCredential -ScriptBlock $ADGetGroupsScriptBlock
}
catch
{
	$LogMessage="Log from GetADUsersInfomation.ps1 Invoke-command Get-ADGroup fail ,获取AD用户组失败"
	Fun_OutputLogs $LogMessage
}

# Delete dbo.DepartmentsUsers content

$Query="
		use CamcWebReport;
		truncate table dbo.DepartmentsUsers;"
Fun_InputDatabase $Query $SQLServerInstance $SQLUserName $SQLPassword $CallFrom


# Get users
foreach ($GroupLine in $ADGroups)
{
	$ADGroupName=$GroupLine.name
	$ADGetUsersScriptBlock=
	{
		(Import-Module ActiveDirectory);
		(Get-ADGroupMember -Identity $using:ADGroupName)
	}

	try
	{
		$ADUsers=Invoke-Command -ComputerName $ADComputerName -Credential $ADCredential -ScriptBlock $ADGetUsersScriptBlock
		#Invoke-Command -ComputerName $ADComputerName -Credential $ADCredential -ScriptBlock $ADGetUsersScriptBlock
	}
	catch
	{
		$LogMessage="Log from GetADUsersInfomation.ps1 Invoke-command Get-ADGroupMember fail ,获取AD用户失败"
		Fun_OutputLogs $LogMessage
	}

	# Output to database
	foreach ($ADUserLine in $ADUsers)
	{
		# Find group members if it is object user then input to database
		if ($ADUserLine.objectClass -eq "user")
		{
			# Data veriables
			$ADUsername=$ADUserLine.SamAccountName
			$ADUserFullname=$ADUserLine.name
			$ADUid=$ADUserLine.SID
			$ADDepartment=$GroupLine.name
			$ADDepartmentGID=$GroupLine.SID
			$GetTime=Get-Date

			# Sql query statements
			$Query="
			use CamcWebReport;
			insert into dbo.DepartmentsUsers
			(
				UserName,
				FullUserName,
				UID,
				Department,
				GID,
				GetTime
			)
			values
			(
				'$ADUsername',
				'$ADUserFullname',
				'$ADUid',
				'$ADDepartment',
				'$ADDepartmentGID',
				'$GetTime'
			)"

			# Output AD data to database
			Fun_InputDatabase $Query $SQLServerInstance $SQLUserName $SQLPassword $CallFrom
		}
	}
}
