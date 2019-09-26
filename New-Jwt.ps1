<#
.Synopsis
	Generates a JSON Web Token (JWT)

.Parameter Body
    A hash of JWT body elements.

.Parameter Headers
    Custom headers (beyond typ and alg) to add to the JWT.

.Parameter Secret
    A secret used to sign the JWT.

.Parameter Algorithm
	The hashing algorithm class to use when signing the JWT.

.Parameter Issuer
	A string or URI (if it contains a colon) indicating the entity that issued the JWT.

.Parameter Subject
	The principal (user) of the JWT as a string or URI (if it contains a colon).

.Parameter Audience
	A string or URI (if it contains a colon), or a list of string or URIs that indicates who the JWT is intended for.

.Parameter ExpirationTime
    When the JWT expires.

.Parameter IssuedAt
    Specifies when the JWT was issued.

.Parameter NotBefore
	When the JWT becomes valid.

.Parameter JwtId
	A unique (at least within a given issuer) identifier for the JWT.

.Parameter IncludeIssuedAt
	Indicates the issued time should be included, based on the current datetime.

.Outputs
    System.String of an encoded, signed JWT

.Link
    Test-Uri.ps1

.Link
	https://tools.ietf.org/html/rfc7519

.Link
	https://jwt.io/

.Link
	https://docs.microsoft.com/dotnet/api/system.security.cryptography.hmac

.Example
	New-Jwt.ps1 -Subject 1234567890 -IssuedAt 2018-01-18T01:30:22Z -Secret (ConvertTo-SecureString swordfish -AsPlainText -Force)

    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE1MTYyMzkwMjIsInN1YiI6IjEyMzQ1Njc4OTAifQ.-zAn1et1mf6QHakJbOTt5-p4gv33R7cIikKy8-9aiNs
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[ValidateNotNull()][System.Collections.IDictionary] $Body = @{},
[ValidateNotNull()][System.Collections.IDictionary] $Headers = @{},
[Parameter(Mandatory=$true)][ValidateNotNull()][securestring] $Secret,
[ValidateSet('HS256','HS384','HS512')][ValidateNotNull()][string] $Algorithm = 'HS256',
[ValidateNotNullOrEmpty()][ValidateScript({if($_.Contains(':')){return Test-Uri.ps1 $_}else{$true}})][string] $Issuer,
[ValidateNotNullOrEmpty()][ValidateScript({if($_.Contains(':')){return Test-Uri.ps1 $_}else{$true}})][string] $Subject,
[ValidateScript({foreach($s in $_){if($s.Contains(':') -and !(Test-Uri.ps1 $s)){return $false}};return $true})]
[ValidateCount(1,2147483647)][System.String[]] $Audience,
[datetime] $ExpirationTime,
[datetime] $NotBefore,
[Parameter(ParameterSetName='IssuedAt')][datetime] $IssuedAt,
[ValidateNotNullOrEmpty()][string] $JwtId,
[Parameter(ParameterSetName='IncludeIssuedAt')][switch] $IncludeIssuedAt
)

function ConvertTo-Base64Url([byte[]]$b) {[Convert]::ToBase64String($b).Trim('=') -replace '\+','-' -replace '/','_'}
function ConvertTo-JSON64($o) {ConvertTo-Base64Url ([Text.Encoding]::UTF8.GetBytes((ConvertTo-Json $o -Compress)))}
function ConvertTo-NumericDate([datetime]$d)
{
    if($d.Kind -eq 'Utc') {[int](Get-Date $d -UFormat %s)}
    else {[int](Get-Date $d.ToUniversalTime() -UFormat %s)}
}

$Headers['alg'] = $Algorithm
$Headers['typ'] = 'JWT'
if($Issuer) {$Body['iss'] = $Issuer}
if($Subject) {$Body['sub'] = $Subject}
if($Audience) {$Body['aud'] = $Audience}
if($ExpirationTime) {$Body['exp'] = ConvertTo-NumericDate $ExpirationTime}
if($IssuedAt) {$Body['iss'] = ConvertTo-NumericDate $IssuedAt}
if($NotBefore) {$Body['nbf'] = ConvertTo-NumericDate $NotBefore}
if($IncludeIssuedAt) {$Body['iss'] = ConvertTo-NumericDate (Get-Date)}
$jwt = "$(ConvertTo-JSON64 $Headers).$(ConvertTo-JSON64 $Body)"
$secred = New-Object pscredential 'secret',$Secret
[byte[]]$secbytes = [Text.Encoding]::UTF8.GetBytes($secred.GetNetworkCredential().Password)
$enc = New-Object "Security.Cryptography.$($Algorithm -replace '\AHS','HMACSHA')" (,$secbytes)
$secbytes = $null
$jwt = "$jwt.$(ConvertTo-Base64Url ($enc.ComputeHash([Text.Encoding]::UTF8.GetBytes($jwt))))"
$enc.Dispose()
$jwt
