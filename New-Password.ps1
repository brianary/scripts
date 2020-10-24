<#
.Synopsis
	Generate a new password.

.Parameter Length
	The length of the password in characters.

.Parameter MaxRepeats
	The maximum number of times a character may be repeated consecutively.

.Parameter ValidMatch
	A regular expression the password must match.

.Parameter InvalidMatch
	A regular expression the password must not match.

.Parameter AsSecureString
	Converts the password to a secure string.

.Parameter TryMaxTimes
	The most attempts that should be made to generate an acceptable password before failing.

.Parameter HasNumber
	Indicates the password must contain a numeric character.

.Parameter HasUpper
	Indicates the password must contain an uppercase letter.

.Parameter HasLower
	Indicates the password must contain a lowercase letter.

.Parameter HasSpecial
	Indicates the password must contain a special character (something that isn't a letter or number).

.Outputs
	System.String containing a generated password, or
	System.Security.SecureString containing a generated password if requested.

.Link
	Invoke-RestMethod

.Link
	https://duckduckgo.com/api

.Example
	New-Password.ps1 64

	-pTs[_?B0S6uqqBquWfB%f*FWPO)X6AEt|>}(V&|%%A-n^OSw!Z9#G/3s=LL;(Uq

.Example
	New-Password.ps1 32 -InvalidMatch '[ \\@]'

	Y]Mo*>V0KUB$*V*j2J%YHsOvp:Ui^{L;

.Example
	New-Password 12 -HasNumber -HasUpper -HasLower -HasSpecial

	ecRAgbdX^9)=
#>

#Requires -Version 3
#Requires -Assembly System.Web
using assembly System.Web
[CmdletBinding()][OutputType([string],[SecureString])] Param(
[Parameter(Position=0,Mandatory=$true)][int] $Length,
[int] $MaxRepeats,
[regex] $ValidMatch,
[regex] $InvalidMatch,
[Alias('SecureString')][switch] $AsSecureString,
[int] $TryMaxTimes = 100,
[switch] $HasNumber,
[switch] $HasUpper,
[switch] $HasLower,
[switch] $HasSpecial
)
$i = 0
while($true)
{
	$i++
	if($i -gt $TryMaxTimes)
	{ Stop-ThrowError.ps1 "Failed to meet requirements after $TryMaxTimes tries." -OperationContext $PSBoundParameters }
	$pwd =
		try {[Web.Security.Membership]::GeneratePassword($Length,3)}
		catch
		{
			$a = Invoke-RestMethod "https://api.duckduckgo.com/?q=pwgen+strong+$Length&format=json"
			[Web.HttpUtility]::HtmlDecode($a.Answer) -replace ' \(random password\)\z',''
		}
	if($MaxRepeats -gt 1 -and $pwd -match "(.)$('\1' * $MaxRepeats)")
	{Write-Verbose "Password #$i has too many duplicate characters"; continue}
	if($ValidMatch -and $pwd -notmatch $ValidMatch) {Write-Verbose "Password #$i not valid: $pwd"; continue}
	if($InvalidMatch -and $pwd -match $InvalidMatch) {Write-Verbose "Password #$i invalid: $pwd"; continue}
	if($HasNumber -and $pwd -notmatch '\d') {Write-Verbose "Password #$i missing number: $pwd"; continue}
	if($HasUpper -and $pwd -cnotmatch '\p{Lu}') {Write-Verbose "Password #$i missing uppercase: $pwd"; continue}
	if($HasLower -and $pwd -cnotmatch '\p{Ll}') {Write-Verbose "Password #$i missing lowercase: $pwd"; continue}
	if($HasSpecial -and $pwd -inotmatch '[^0-9A-Z]') {Write-Verbose "Password #$i missing lowercase: $pwd"; continue}
	break
}
if($AsSecureString) {ConvertTo-SecureString $pwd -AsPlainText -Force}
else {$pwd}
