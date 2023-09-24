<#
.SYNOPSIS
Removes an article from a Pocket account.
#>


#Requires -Version 3
#Requires -Modules Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText','',
Justification='This value has to be converted to text to be sent in a text body.')]
[CmdletBinding(SupportsShouldProcess=$true)][OutputType([psobject])] Param(
)
Process
{
	
}
