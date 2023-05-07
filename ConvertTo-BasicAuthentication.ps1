<#
.SYNOPSIS
Produces a basic authentication header string from a credential.

.INPUTS
System.Management.Automation.PSCredential to convert to the Authorization HTTP header value.

.OUTPUTS
System.String to use as the Authorization HTTP header value.

.FUNCTIONALITY
HTTP

.LINK
https://tools.ietf.org/html/rfc1945#section-11.1

.LINK
http://stackoverflow.com/q/24672760/54323

.LINK
https://weblog.west-wind.com/posts/2010/Feb/18/NET-WebRequestPreAuthenticate-not-quite-what-it-sounds-like

.LINK
https://powershell.org/forums/topic/pscredential-parameter-help/

.EXAMPLE
Invoke-RestMethod https://example.com/api/items -Method Get -Headers @{Authorization=ConvertTo-BasicAuthentication.ps1 (Get-Credential -Message 'Log in')}

Calls a REST method that requires Basic authentication on the first request (with no challenge-response support).
#>

[CmdletBinding()][OutputType([string])] Param(
# Specifies a user account to authenticate an HTTP request that only accepts Basic authentication.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[PSCredential][Management.Automation.Credential()]$Credential
)
Process
{
	return 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(
		"$($Credential.UserName):$($Credential.Password |ConvertFrom-SecureString -AsPlainText)"))
}

