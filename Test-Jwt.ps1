<#
.SYNOPSIS
Determines whether a string is a valid JWT.

.INPUTS
System.String value to test for a valid URI format.

.OUTPUTS
System.Boolean indicating that the string can be parsed as a URI.

.FUNCTIONALITY
Data formats

.EXAMPLE
Test-Jwt.ps1 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE1MTYyMzkwMjIsInN1YiI6IjEyMzQ1Njc4OTAifQ.-zAn1et1mf6QHakJbOTt5-p4gv33R7cIikKy8-9aiNs' (ConvertTo-SecureString swordfish -AsPlainText -Force)

True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
# The string to test.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][AllowEmptyString()][AllowNull()][string] $InputObject,
# The secret used to sign the JWT.
[Parameter(Position=1,Mandatory=$true)][SecureString] $Secret
)
Process
{
    if(!$InputObject) {Write-Verbose 'No JWT input'; return $false}
    if(!$InputObject.Contains([char]'.')) {Write-Verbose 'JWT is missing a dot'; return $false}
    $head64,$body64,$sign64 = $InputObject -split '\.'
    $head = ConvertFrom-Base64.ps1 $head64 utf8 -UriStyle
    Write-Verbose "JWT head: $head"
    if(!(Test-Json $head)) {Write-Verbose 'JWT header does not decode to valid JSON'; return $false}
    $head = ConvertFrom-Json $head
    if($head.typ -ne 'JWT') {Write-Verbose "JWT type is $($head.typ)"; return $false}
    if($head.alg -notin 'HS256','HS384','HS512') {Write-Verbose "Unsupported algorithm: $($head.alg)"; return $false}
    $body = ConvertFrom-Base64.ps1 $body64 utf8 -UriStyle
    Write-Verbose "JWT body: $body"
    if(!(Test-Json $body)) {Write-Verbose 'JWT body does not decode to valid JSON'; return $false}
    $body = ConvertFrom-Json $body
    [byte[]]$sign = ConvertFrom-Base64.ps1 $sign64 -UriStyle
    $secred = New-Object pscredential 'secret',$Secret
    [byte[]]$secbytes = [Text.Encoding]::UTF8.GetBytes(($secred.Password |ConvertFrom-SecureString -AsPlainText))
    $hash = New-Object "Security.Cryptography.$($head.alg -replace '\AHS','HMACSHA')" (,$secbytes)
    if(Compare-Object $sign ($hash.ComputeHash([Text.Encoding]::UTF8.GetBytes("$head64.$body64"))))
    {Write-Verbose "JWT hashes do not match"; return $false}
    return $true
}

