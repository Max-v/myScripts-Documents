if ($bRemoveDissmisedUserMsolMailbox -eq $true) {
									$objReport.UUA.nRemovedMailboxReqCount++
									Message("Remove a remote mailbox "+$objUserAccount.Name.value) $nLogChangesRepInfo
									Disable-RemoteMailbox $objUserAccount.userPrincipalName.Value -Confirm:$false
									$objReport.UUA.nRemovedMailboxCount++
								}