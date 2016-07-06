#
# ModOuputConfig.psm1
#

# Function output to config file
function Fun_OutputConfig
{
    param ($ComputerNameString, $ComputerName, $UserString, $User, $PasswordString, $Password)
    
    # function Fun_IsStringExsit
    function Fun_IsStringExsit
    {
        param($IsString, $Content)
        $Flag=$false
        foreach ($Line in $Content)
        {
            if ($Line.Contains($IsString))
            {
                $Flag=$true
                return $Line
            }
        }
        return $Flag
    }

    
    if (Test-Path .\Config)
    {
        # Config file is exsit
        $ConfigContentArray=New-Object System.Collections.ArrayList
        $ConfigContent=Get-Content .\Config
        
        foreach($Line in $ConfigContent)
        {
            $ConfigContentArray.Add($Line) | Out-Null
        }

        # ComputerName

        $ReturnFun=Fun_IsStringExsit $ComputerNameString $ConfigContentArray

        if ($ReturnFun)
        {
            $StringIndex=$ConfigContentArray.IndexOf($ReturnFun)
            $ConfigContentArray.Remove($ReturnFun)
            $ConfigContentArray.Insert($StringIndex,"$ComputerNameString=$ComputerName")
        }
        elseif ($ReturnFun -eq $false)
        {
            $ConfigContentArray.Add("$ComputerNameString=$ComputerName") | Out-Null
        }

        # User

        $ReturnFun=Fun_IsStringExsit $UserString $ConfigContentArray

        if ($ReturnFun)
        {
            $StringIndex=$ConfigContentArray.IndexOf($ReturnFun)
            $ConfigContentArray.Remove($ReturnFun)
            $ConfigContentArray.Insert($StringIndex,"$UserString=$User")
        }
        elseif ($ReturnFun -eq $false)
        {
            $ConfigContentArray.Add("$UserString=$User") | Out-Null
        }

        # Password

        $ReturnFun=Fun_IsStringExsit $PasswordString $ConfigContentArray

        if ($ReturnFun)
        {
            $StringIndex=$ConfigContentArray.IndexOf($ReturnFun)
            $ConfigContentArray.Remove($ReturnFun)
            $ConfigContentArray.Insert($StringIndex,"$PasswordString=$Password")
        }
        elseif ($ReturnFun -eq $false)
        {
            $ConfigContentArray.Add("$PasswordString=$Password") | Out-Null
        }

		# Output $ConfigContentArray to .\Config
        Out-File -FilePath .\Config -InputObject $ConfigContentArray
    }
    else
    {
        # Config file is not exsit
        Out-File -FilePath .\Config -InputObject "$ComputerNameString=$ComputerName" -Append
        Out-File -FilePath .\Config -InputObject "$UserString=$User" -Append
        Out-File -FilePath .\Config -InputObject "$PasswordString=$Password" -Append
    }
} 