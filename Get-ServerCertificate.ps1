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
#>

#Requires -Version 7
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
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 (,
            [Text.Encoding]::UTF8.GetBytes($serialized))
        return [pscustomobject]@{
            Server      = $Server
            Subject     = $cert.Subject
            Issuer      = $cert.Issuer
            Issued      = $cert.NotBefore
            Expires     = $cert.NotAfter
            Thumbprint  = $cert.Thumbprint
            Certificate = $cert
        }
    }
}
Process
{
    $Server |Get-ServerCertificate
}
