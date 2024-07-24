<#
.SYNOPSIS
Returns the certificate provided by the requested server.

.FUNCTIONALITY
TLS/SSL

.LINK
Use-Command.ps1

.EXAMPLE
Get-ServerCertificate.ps1 webcoder.info

Server      : webcoder.info
Subject     : CN=webcoder.info
Issuer      : CN=R11, O=Let's Encrypt, C=US
Issued      : 2024-07-06 15:51:57
Expires     : 2024-10-04 15:51:56
Thumbprint  : 363A8CBAB35E6F3254CBB52FE00D0E0E0B3606BC
Certificate : [Subject]...
Extensions  : {[Subject Alternative Name, DNS Name=...
Chain       : System.Security.Cryptography.X509Certificates.X509Chain
#>

#Requires -Version 7
using namespace System.Security.Cryptography
using namespace System.Security.Cryptography.X509Certificates
[CmdletBinding()] Param(
# The server (hostname) to return the TLS/SSL certificate from.
[Parameter(Position=0,Mandatory=$true,ValueFromRemainingArguments=$true)][string[]] $Server
)
Begin
{
	Use-Command.ps1 openssl "$env:SystemRoot\openssl.exe" -cinst openssl.light

	filter Get-ServerCertificate
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Server
		)
		$name = $Server -replace ':\d+\z'
		$serverPort = $Server -like '*:*' ? $Server : "${Server}:443"
		$serialized =  'Q' |openssl s_client -servername $name -connect $serverPort 2>NUL |Out-String
		$cert = New-Object X509Certificate2 (,[Text.Encoding]::UTF8.GetBytes($serialized))
		$chain = New-Object X509Chain
		[void]$chain.Build($cert)
		$ext = @{}
		$cert.Extensions |ForEach-Object {$ext.Add($_.Oid.FriendlyName, (New-Object AsnEncodedData $_.Oid, $_.RawData).Format($true).Trim())}
		return [pscustomobject]@{
			Server      = $Server
			Subject     = $cert.Subject
			AltNames    = $ext.ContainsKey('Subject Alternative Name') ? $ext['Subject Alternative Name'] : $null
			Issuer      = $cert.Issuer
			Issued      = $cert.NotBefore
			Expires     = $cert.NotAfter
			Thumbprint  = $cert.Thumbprint
			Certificate = $cert
			Extensions  = $ext
			Chain       = $chain
		}
	}
}
Process
{
	$Server |Get-ServerCertificate
}
