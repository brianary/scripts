<#
.Synopsis
    Produces a basic authentication header string from a credential.

.Credential
    Specifies a user account to authenticate an HTTP request that only accepts Basic authentication.

.Link
    https://tools.ietf.org/html/rfc1945#section-11.1

.Link
    http://stackoverflow.com/q/24672760/54323

.Link
    https://weblog.west-wind.com/posts/2010/Feb/18/NET-WebRequestPreAuthenticate-not-quite-what-it-sounds-like

.Example
    Invoke-RestMethod https://example.com/api/items -Method Get -Headers @{Authorization=ConvertTo-BasicAuthentication.ps1 (Get-Credential -Message 'Log in')}

    Calls a REST method that requires Basic authentication on the first request (with no challenge-response support).
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][PSCredential]$Credential
)

'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($Credential.UserName+':'+$Credential.GetNetworkCredential().Password))