<#
.SYNOPSIS
Shows the permissions of a certificate's private key file.

.INPUTS
System.Security.Cryptography.X509Certificates.X509Certificate2 to show the permissions
of the private key file of.

.LINK
Get-CertificatePermissions.ps1

.LINK
Format-Certificate.ps1

.EXAMPLE
Show-CertificatePermissions.ps1 -Certificate $cert

Displays the permissions for the certificate in $cert.

.EXAMPLE
Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Show-CertificatePermissions

Displays the permissions for the certificate.

.EXAMPLE
$c = Find-Certificate.ps1 ExampleCert FindBySubjectName TrustedPeople LocalMachine ; Show-CertificatePermissions.ps1 $c

Another approach to display cert permissions.

.EXAMPLE
Find-Certificate.ps1 $issuername FindByIssuerName -Valid |Show-CertificatePermissions.ps1 |Out-File certperms.txt utf8

Save valid certificate permissions from a given issuer to a file.
#>

[CmdletBinding()][OutputType([void])] Param(
# The certificate to display permissions for.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
Process
{
    if(!$Certificate.HasPrivateKey) {return}
    Format-Certificate.ps1 $Certificate |Write-Output
    Get-CertificatePermissions.ps1 -Certificate $Certificate |
        select IdentityReference,AccessControlType,FileSystemRights |
        Format-Table -AutoSize
}
