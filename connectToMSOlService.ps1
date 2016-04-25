-------------------------------------------------------------------------------

function ConnectToMsolService
{
	if ($bMsolServiceConnected -eq $true) { return $true }
	
	$script:bMsolServiceConnected = $false
	
	Message "Connect to MSOL sevice..." $nLogInfo
	
	try {
		$SecurePassword = $strMsolAdminPas | ConvertTo-SecureString -AsPlainText -Force
		$objCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList $strMsolAdminLog, $SecurePassword
	}
	catch {
		WriteErr $_ "prepare credentials for MSOL sevice"
		return $false
	}
	
	try {
		$objO365Session = New-PSSession -ConfigurationName Microsoft.Exchange `
			-ConnectionUri "https://ps.outlook.com/powershell" -Credential $objCredentials `
			-Authentication Basic -AllowRedirection 
		Import-PSSession $objO365Session -AllowClobber -Prefix "O365"
		Import-Module MSOnline
		Connect-MSOLService -Credential $objCredentials
	}
	catch {
		WriteErr $_ "connect to MSOL sevice"
		return $false
	}
	
	$script:bMsolServiceConnected = $true
	return $true
}
