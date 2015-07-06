<#
.Synopsis
    Shows the permissions of a certificate's private key file.

.Parameter Certificate
    The certificate to display permissions for.

.Link
    Find-Certificate.ps1

.Example
    Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Show-CertificatePermissions
    Displays the permissions for the certificate.
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
ls "$env:ProgramData\Microsoft\Crypto\RSA\MachineKeys","$env:APPDATA\Microsoft\Crypto\RSA" -Recurse -Filter $cert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName |% FullName |% {icacls $_}
