<#
.SYNOPSIS
Generates a JSON Web Token (JWT)

.OUTPUTS
System.String of an encoded, signed JWT

.FUNCTIONALITY
Data formats

.LINK
ConvertTo-Base64.ps1

.LINK
Test-Uri.ps1

.LINK
https://tools.ietf.org/html/rfc7519

.LINK
https://jwt.io/

.LINK
https://docs.microsoft.com/dotnet/api/system.security.cryptography.hmac

.EXAMPLE
New-Jwt.ps1 -Subject 1234567890 -IssuedAt 2018-01-18T01:30:22Z -Secret (ConvertTo-SecureString swordfish -AsPlainText -Force)

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWF0IjoxNTE2MjM5MDIyfQ.59noQVrGQKetFM3RRTe9m4MVBUMkLo3WxqqpPf1xJ-U
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# A hash of JWT body elements.
[ValidateNotNull()][System.Collections.IDictionary] $Body = @{},
# Custom headers (beyond typ and alg) to add to the JWT.
[ValidateNotNull()][System.Collections.IDictionary] $Headers = @{},
# A secret used to sign the JWT.
[Parameter(Mandatory=$true)][ValidateNotNull()][securestring] $Secret,
# The hashing algorithm class to use when signing the JWT.
[ValidateSet('HS256','HS384','HS512')][ValidateNotNull()][string] $Algorithm = 'HS256',
# When the JWT becomes valid.
[datetime] $NotBefore,
# Specifies when the JWT was issued.
[datetime] $IssuedAt,
# Indicates the issued time should be included, based on the current datetime (ignored if IssuedAt is provided).
[switch] $IncludeIssuedAt,
# When the JWT expires.
[datetime] $ExpirationTime,
# How long from now until the JWT expires (ignored if ExpirationTime is provided).
[timespan] $ExpiresAfter,
# A unique (at least within a given issuer) identifier for the JWT.
[ValidateNotNullOrEmpty()][string] $JwtId,
# A string or URI (if it contains a colon) indicating the entity that issued the JWT.
[ValidateNotNullOrEmpty()][ValidateScript({if($_.Contains(':')){return Test-Uri.ps1 $_}else{$true}})][string] $Issuer,
# The principal (user) of the JWT as a string or URI (if it contains a colon).
[ValidateNotNullOrEmpty()][ValidateScript({if($_.Contains(':')){return Test-Uri.ps1 $_}else{$true}})][string] $Subject,
# A string or URI (if it contains a colon), or a list of string or URIs that indicates who the JWT is intended for.
[ValidateScript({foreach($s in $_){if($s.Contains(':') -and !(Test-Uri.ps1 $s)){return $false}};return $true})]
[ValidateCount(1,2147483647)][System.String[]] $Audience,
# Additional claims to add to the body of the JWT.
[hashtable] $Claims = @{}
)

function ConvertTo-JSON64($o) {ConvertTo-Base64.ps1 ([Text.Encoding]::UTF8.GetBytes((ConvertTo-Json $o -Compress))) -UriStyle}
function ConvertTo-NumericDate([datetime]$d)
{
	if($d.Kind -eq 'Utc') {[int](Get-Date $d -UFormat %s)}
	else {[int](Get-Date $d.ToUniversalTime() -UFormat %s)}
}
function ConvertFrom-NumericDate([int]$i)
{
	if(!$i) {return}
	(New-Object datetime 1970,1,1,0,0,0,([DateTimeKind]::Utc)).AddSeconds($i).ToLocalTime()
}

$Headers['alg'] = $Algorithm
$Headers['typ'] = 'JWT'
if($NotBefore) {$Body['nbf'] = ConvertTo-NumericDate $NotBefore}
if($IncludeIssuedAt) {$Body['iat'] = ConvertTo-NumericDate (Get-Date)}
elseif($IssuedAt) {$Body['iat'] = ConvertTo-NumericDate $IssuedAt}
if($ExpirationTime) {$Body['exp'] = ConvertTo-NumericDate $ExpirationTime}
elseif($ExpiresAfter) {$Body['exp'] = ConvertTo-NumericDate ((Get-Date).Add($ExpiresAfter))}
'iat','nbf','exp' |ForEach-Object {Set-Variable $_ $(if($Body.ContainsKey($_)){ConvertFrom-NumericDate $Body[$_]}else{'whenever'})}
Write-Verbose "JWT issued $iat valid $nbf to $exp"
if($JwtId) {$Body['jti'] = $JwtId}
if($Issuer) {$Body['iss'] = $Issuer}
if($Subject) {$Body['sub'] = $Subject}
if($Audience) {$Body['aud'] = $Audience}
$Body += $Claims
Write-Verbose "JWT headers: $(ConvertTo-Json $Headers -Compress)"
Write-Verbose "JWT body: $(ConvertTo-Json $Body -Compress)"
$jwt = "$(ConvertTo-JSON64 $Headers).$(ConvertTo-JSON64 $Body)"
Write-Verbose "Unsigned JWT: $jwt"
$secred = New-Object pscredential 'secret',$Secret
[byte[]]$secbytes = [Text.Encoding]::UTF8.GetBytes(($secred.Password |ConvertFrom-SecureString -AsPlainText))
$hash = New-Object "Security.Cryptography.$($Algorithm -replace '\AHS','HMACSHA')" (,$secbytes)
$secbytes = $null
Write-Verbose "Signing JWT with $($hash.GetType().Name)"
$jwt = "$jwt.$(ConvertTo-Base64.ps1 ($hash.ComputeHash([Text.Encoding]::UTF8.GetBytes($jwt))) -UriStyle)"
$hash.Dispose()
$jwt
