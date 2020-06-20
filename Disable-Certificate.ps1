<#
.Synopsis
    Sets the Archived property on a certificate.

.Parameter Certificate
    The certificate to archive.

.Inputs
    System.Security.Cryptography.X509Certificates.X509Certificate2 to set as Archived.

.Link
    Find-Certificate.ps1

.Link
    https://docs.microsoft.com/dotnet/api/system.security.cryptography.x509certificates.x509certificate2.archived

.Example
    Disable-Certificate.ps1 -Certificate $cert

    Sets $cert.Archived to $true.

.Example
    Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Disable-Certificate.ps1

    Sets the found ExampleCert as archived.

    For more information about options for -FindType:
    https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx

.Example
    Get-Item Cert:\CurrentUser\My\F397B30796BE1E1D11C34B6893A2F035844FD936 |Disable-Certificate.ps1

    Sets the certificate as archived.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding(ConfirmImpact='Medium',SupportsShouldProcess=$true)][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
Process
{
    $Certificate.Archived = $true
}
