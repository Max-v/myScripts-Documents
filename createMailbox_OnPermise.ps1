{ # --- Create mailbox On-Premise
	
		$objReport.UUA.nNewMailboxReqCount++
		Message("Create mailbox for `""+$objUser.Name.Value+"`" in database "+$strMailboxDatabase) $nLogChangesInfo
	
		try {
			$objMailbox = Enable-Mailbox -Identity $strUserLogin -Alias $strUserLogin -Database $strMailboxDatabase
			$objReport.UUA.nNewMailboxCount++
		}
		catch {
			WriteErr $_ ("create mailbox for `""+$objUser.Name.Value+"`"")
			return $false
		}
	}