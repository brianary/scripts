<#
.Synopsis
    Generate a new password.

.Parameter Length
    The length of the password in characters.

.Link
    Invoke-RestMethod
    https://duckduckgo.com/api

.Example
    New-Password.ps1 64

    -pTs[_?B0S6uqqBquWfB%f*FWPO)X6AEt|>}(V&|%%A-n^OSw!Z9#G/3s=LL;(Uq
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][int]$Length
)
try
{
    $a = Invoke-RestMethod "https://api.duckduckgo.com/?q=pwgen+strong+$Length&format=json"
    [Net.HttpUtility]::HtmlDecode($a.Answer) -replace ' \(random password\)\z',''
}
catch {[Web.Security.Membership]::GeneratePassword($Length,3)}
