#
# GetCitrixDDCInformation.ps1
#

$WorkPath="E:\Scripts\Ps\WebReport\WebReport"

# Import mudlules
Import-Module $WorkPath\Modules\ModCredential\ModCredential.psm1
Import-Module $WorkPath\Modules\ModOutputLogs\ModOutputLogs.psm1
Import-Module $WorkPath\Modules\ModReadConfig\ModReadConfig.psm1
Import-Module $WorkPath\Modules\ModInvokeCommand\ModInvokeCommand.psm1
Import-Module $WorkPath\Modules\ModInputDatabase\ModInputDatabase.psm1
Import-Module $WorkPath\Modules\ModDDCDataOutputDatabase\ModDDCDataOutputDatabase.psm1

# {------ Function Get-BrokerApplicationInstance ------

# Function Get-BrokerApplicationInstance
function Fun_BrokerApplicationInstance
{
	param ($ComputerName, $Credential)
	# Set scriptblock
	$ScriptBlock=
	{
		Add-PSSnapin Citrix*; 
		Get-BrokerApplicationInstance
	}

	# Sign me as ddc 
	$CallFrom="DDC Get-BrokerApplicationInstance"

	# Get Citrix DDC's information
	$DDCInformation=Fun_InvokeCommand $ComputerName $Credential $ScriptBlock $CallFrom
	if ($DDCInformation -eq $false)
	{
		$LogMessage="Log from GetCitrixDDCInformation.ps1 Invoke-command DDC Get-BrokerApplicationInstance 数据失败"
		Fun_OutputLogs $LogMessage
	}

	# Insert data into database with foreach
	foreach ($DDCInformationLine in $DDCInformation)
	{
		# Data variables
		$ApplicationName=$DDCInformationLine.ApplicationName
		$MachineName=$DDCInformationLine.MachineName
		$SessionKey=$DDCInformationLine.SessionKey
		$UserName=$DDCInformationLine.UserName
		$GetTime=Get-Date

		# Sql query statements
		$Query="
		use CamcWebReport; 
		insert into dbo.BrokerApplicationInstance 
		(
			ApplicationName, 
			MachineName, 
			SessionKey, 
			UserName, 
			GetTime
		) 
		values 
		(
			'$ApplicationName',
			'$MachineName',
			'$SessionKey',
			'$UserName',
			'$GetTime'
		)"

		# Output DDC Get-BrokerApplicationInstance to table dbo.BrokerApplicationInstance
		Fun_DDCDataOutputDatabase $Query $CallFrom
	}
}

# ------ Function Get-BrokerApplicationInstance ------}


# {------ Function Get-BrokerSession ------

# Function Get-BrokerSession
function Fun_BrokerSession
{
	param ($ComputerName, $Credential)
	# Set scriptblock
	$ScriptBlock=
	{
		Add-PSSnapin Citrix*; 
		Get-BrokerSession
	}

	# Sign me as ddc 
	$CallFrom="DDC Get-BrokerSession"

	# Get Citrix DDC's information
	$DDCInformation=Fun_InvokeCommand $ComputerName $Credential $ScriptBlock $CallFrom
	if ($DDCInformation -eq $false)
	{
		$LogMessage="Log from GetCitrixDDCInformation.ps1 Invoke-command DDC Get-BrokerSession 数据失败"
		Fun_OutputLogs $LogMessage
	}

	# Insert data into database with foreach
	foreach ($DDCInformationLine in $DDCInformation)
	{
		# Data variables
		$AppState=$DDCInformationLine.AppState
		$ApplicationsInUse=$DDCInformationLine.ApplicationsInUse
		$ConnectedViaHostName=$DDCInformationLine.ConnectedViaHostName
		$ConnectedViaIP=$DDCInformationLine.ConnectedViaIP
		$DesktopGroupName=$DDCInformationLine.DesktopGroupName
		$MachineName=$DDCInformationLine.MachineName
		$SessionKey=$DDCInformationLine.SessionKey
		$SessionState=$DDCInformationLine.SessionState
		$UserFullName=$DDCInformationLine.UserFullName
		$UserName=$DDCInformationLine.UserName
		$GetTime=Get-Date

		# Sql query statements
		$Query="
		use CamcWebReport; 
		insert into dbo.BrokerSession 
		(
			AppState,
			ApplicationsInUse,
			ConnectedViaHostName,
			ConnectedViaIP,
			DesktopGroupName,
			MachineName,
			SessionKey,
			SessionState,
			UserFullName,
			UserName,
			GetTime
		) 
		values 
		(
			'$AppState',
			'$ApplicationsInUse',
			'$ConnectedViaHostName',
			'$ConnectedViaIP',
			'$DesktopGroupName',
			'$MachineName',
			'$SessionKey',
			'$SessionState',
			'$UserFullName',
			'$UserName',
			'$GetTime'
		)"

		# Output DDC Get-BrokerSession to table dbo.BrokerSession
		Fun_DDCDataOutputDatabase $Query $CallFrom
	}
}

# ------ Function Get-BrokerSession ------}


# ------ DDC Main ------

# Start scripts 
$Logmessage="Starting scripts ......"

# Citrix DDC's computername
$ComputerNameKey="DDCComputerName"
$ComputerName=Fun_ReadConfig $ComputerNameKey

# Citrix DDC's username
$UserNameKey="DDCUserName"
$UserName=Fun_ReadConfig $UserNameKey

# Citrix DDC's password
$PasswordKey="DDCPassword"
$Password=Fun_ReadConfig $PasswordKey

# Get credential variable
$Credential=Fun_Credential $UserName $Password

# Call Function Get-BrokerApplicationInstance
Fun_BrokerApplicationInstance $ComputerName $Credential 

# Call Function Get-BrokerSession
Fun_BrokerSession $ComputerName $Credential


