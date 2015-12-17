<#
.Summary
    Searches a certificate store for a certificate.

.Parameter FindValue
    The value to search for.

.Parameter FindType
    The field of the certificate to compare to FindValue.
    e.g. FindBySubjectName, FindByKeyUsage, FindByIssuerDistinguishedName

.Parameter StoreName
    The name of the certificate store to search.
    e.g. My, TrustedPeople, Root

.Parameter StoreLocation
    Whether to search the certificates of the CurrentUser or the LocalMachine.

.Parameter Current
    Whether to further filter search results by checking the effective and expiration dates.

.Parameter Require
    Whether to throw an error if a certificate is not found.

.Link
    https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx

.Link
    https://msdn.microsoft.com/library/ms148581.aspx

.Link
    https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509certificate2.aspx

.Example
    Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine
    Searches Cert:\LocalMachine\TrustedPeople for a certificate with a subject name of "ExampleCert".

.Example
    Find-Certificate.ps1 ExampleCert FindBySubjectName TrustedPeople LocalMachine
    Uses positional parameters to search Cert:\LocalMachine\TrustedPeople for a cert with subject of "ExampleCert".
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('Certificate','Value')][string]$FindValue,
[Parameter(Position=1,Mandatory=$true)][Alias('Type','Field')][Security.Cryptography.X509Certificates.X509FindType]$FindType,
[Parameter(Position=2,Mandatory=$true)][Security.Cryptography.X509Certificates.StoreName]$StoreName,
[Parameter(Position=3,Mandatory=$true)][Security.Cryptography.X509Certificates.StoreLocation]$StoreLocation,
[switch]$Current,
[switch]$Require
)
$store = New-Object Security.Cryptography.X509Certificates.X509Store $StoreName,$StoreLocation
[void]$store.Open('OpenExistingOnly')
$cert = $store.Certificates.Find($FindType,$FindValue,$true)
[void]$store.Close()
$store = $null
if($Current) { $now = [DateTime]::Now ; $cert = $cert |where NotAfter -gt $now |where NotBefore -lt $now }
if($Require -and !$cert) {throw "Could not find certificate $FindType $FindValue in $StoreLocation $StoreName"}
