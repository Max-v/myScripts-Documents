if ($bCreateMsolMailbox -eq $true -and $arrExpressUserDepartment -contains $strDepId) {
	
		# --- Create mailbox in Exchange Online
		$objReport.UUA.nNewMailboxReqCount++
		if (![string]::IsNullOrEmpty($strMsolTenantDomain)) {
			$strEmailAddresses = $strUserLogin+"@"+$strMsolTenantDomain
			
			Message("Create mailbox for `""+$objUser.Name.Value+"`" in Exchange Online") $nLogChangesInfo
			try {
				Enable-RemoteMailbox $objUser.userPrincipalName.Value -Alias $strUserLogin -RemoteRoutingAddress $strEmailAddresses
				$objReport.UUA.nNewMailboxCount++
				$script:bMsolNeedDirSync = $true
			}
			catch {
				WriteErr $_ ("create remote mailbox for `""+$objUser.Name.Value+"`"")
				return $false
			}
			
			$objReport.UUA.nAssignedMsolLicensesReqCount++
			Message("Postpone add license") $nLogVerboseInfo
			$objUserParam.AddPostponedAction("bPostponedMsolAddLicense")
			Message("Postpone set user location") $nLogVerboseInfo
			$objUserParam.AddPostponedAction("bPostponedMsolSetUserLocation")
			
			try {
				$objMailbox = Get-RemoteMailbox $objUser.userPrincipalName.Value
			}
			catch {
				WriteErr $_ ("get remote mailbox of `""+$objUser.Name.Value+"`"")
				return $false
			}
			
			Message("Add email `""+$strEmailAddresses+"`" to mailbox of `""+$objUser.Name.Value+"`"") $nLogChangesInfo
			try {
				Set-RemoteMailbox $objUser.userPrincipalName.Value -EmailAddresses @{add=($strEmailAddresses)}
			}
			catch {
				WriteErr $_ ("add email to remote mailbox of `""+$objUser.Name.Value+"`"")
				return $false
			}
		} else {
			WriteErr ("undefined tenant domain in configuration")
			return $false
		}
		
	}