<#
.Synopsis
    Prompts for a certificate and an app pool to grant access to the cert.
    
.Parameter CertStore
    The Cert: provider path to the store to select certificates from.
    Uses Cert:\LocalMachine\TrustedPeople by default.

.Link
    Find-Certificate.ps1
    
.Link
    http://stackoverflow.com/a/21713869/54323

.Link
    https://technet.microsoft.com/en-us/library/ee909471.aspx

.Example
    Grant-AppPoolCertAccess.ps1 -AppPool ExampleAppPool -Certificate $cert
    Grants the ExampleAppPool app pool access to read the cert in $cert.

.Example
    Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Grant-AppPoolCertAccess.ps1 ExampleAppPool
    Grants the ExampleAppPool app pool access to read the found ExampleCert.
#>

#requires -version 3
#requires -Module WebAdministration
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][ValidateScript({Test-Path IIS:\AppPools\$_})][string]$AppPool,
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
Begin
{
try{Get-Command icacls -CommandType Application |Out-Null}catch{throw 'The icacls command is missing.'}
}
Process
{
$cert = $Certificate.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
icacls $env:ProgramData\Microsoft\crypto\rsa\machinekeys\$cert /grant "IIS AppPool\${AppPool}:R"
}
