<#
.Synopsis
    Returns the permissions of a certificate's private key file.

.Parameter Certificate
    The certificate to display permissions for.

.Link
    Find-Certificate.ps1

.Link
    Get-Acl

.Example
    Get-CertificatePermissions.ps1 -Certificate $cert
    Returns the permissions for the certificate in $cert.

.Example
    Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Get-CertificatePermissions
    Returns the permissions for the certificate.

.Example
    $c = Find-Certificate.ps1 ExampleCert FindBySubjectName TrustedPeople LocalMachine ; Get-CertificatePermissions.ps1 $c
    Another approach to get cert permissions.
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
Begin{try{Get-Command Get-Acl -CommandType Cmdlet -ErrorAction SilentlyContinue |Out-Null}catch{throw 'The Get-Acl command is missing.'}}
Process
{
    $path = Get-CertificatePath.ps1 $Certificate
    if($path -and (Test-Path $path -PathType Leaf)) {Get-Acl $path |% Access}
}