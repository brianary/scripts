<#
.Synopsis
    Searches a certificate store for certificates.

.Parameter FindValue
    The value to search for, usually a string.

    For a FindType of FindByTimeValid, FindByTimeNotYetValid, or FindByTimeExpired, the FindValue must be a datetime.
    For a FindType of FindByApplicationPolicy or FindByCertificatePolicy, the FindValue can be a string or a
    System.Security.Cryptography.Oid.
    For a FindType of FindByKeyUsage, the FindValue can be a string or an int bitmask.

.Parameter FindType
    The field of the certificate to compare to FindValue.
    e.g. FindBySubjectName, FindByKeyUsage, FindByIssuerDistinguishedName

    For a FindType of FindByTimeValid, FindByTimeNotYetValid, or FindByTimeExpired, the FindValue should be a datetime.
    For a FindType of FindByApplicationPolicy or FindByCertificatePolicy, the FindValue can be a string or a
    System.Security.Cryptography.Oid.
    For a FindType of FindByKeyUsage, the FindValue can be a string or an int bitmask.

    Omitting a FindType or StoreName will search all stores and common fields.

.Parameter StoreName
    The name of the certificate store to search.
    e.g. My, TrustedPeople, Root

    Omitting a FindType or StoreName will search all stores and common fields.

.Parameter StoreLocation
    Whether to search the certificates of the CurrentUser or the LocalMachine.

    Uses LocalMachine by default.

.Parameter Valid
    Whether to further filter search results by checking the effective and expiration dates.

.Parameter NotArchived
    Whether to further filter search results by excluding certificates marked as archived.

.Parameter Require
    Whether to throw an error if a certificate is not found.

.Outputs
    System.Security.Cryptography.X509Certificates.X509Certificate2[] of found certificates.

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

#Requires -Version 3
[CmdletBinding()][OutputType([Security.Cryptography.X509Certificates.X509Certificate2[]])] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('Certificate','Value')] $FindValue,
[Parameter(Position=1)][Alias('Type','Field')][Security.Cryptography.X509Certificates.X509FindType] $FindType,
[Parameter(Position=2)][Security.Cryptography.X509Certificates.StoreName] $StoreName,
[Parameter(Position=3)][Security.Cryptography.X509Certificates.StoreLocation] $StoreLocation = 'LocalMachine',
[Alias('Current')][switch] $Valid,
[switch] $NotArchived,
[switch] $Require
)
$cert =
    if(!($StoreName -and $FindType))
    {
        Write-Verbose "Find '$FindValue'"
        $now = Get-Date
        ls Cert:\CurrentUser,Cert:\LocalMachine |
            % {ls "Cert:\$($_.Location)\$($_.Name)"} |
            ? {!$NotArchived -or !$_.Archived} |
            ? {$_.Subject,$_.Issuer,$_.Thumbprint |? {$_ -like "*$FindValue*"}} |
            ? {!$Valid -or ($now -ge $_.NotBefore -and $now -le $_.NotAfter)}
    }
    else
    {
        if(('FindByTimeValid','FindByTimeNotYetValid','FindByTimeExpired' -contains $FindType) -and ($FindValue -is [string]))
        { [datetime] $FindValue = $FindValue }
        Write-Verbose "$FindType '$FindValue' ($($FindValue.GetType().Name)) in $StoreLocation\$StoreName"
        $store = New-Object Security.Cryptography.X509Certificates.X509Store $StoreName,$StoreLocation
        [void] $store.Open('OpenExistingOnly')
        $found = $store.Certificates.Find($FindType,$FindValue,$Valid)
        [void] $store.Close()
        $store = $null
        $found |? {!$NotArchived -or !$_.Archived}
    }
if($Require -and !$cert) {throw "Could not find certificate $FindType $FindValue in $StoreLocation $StoreName"}
$cert
