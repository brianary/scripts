<#
.SYNOPSIS
Generates a formatted name/description from a certificate.

.PARAMETER Certificate
The certificate to generate a formatted string from.

.PARAMETER Format
The case-sensitive format string to use. The following letters emit the following values,
all other letters are emitted unchanged, backslash escapes letters:

a  expiration date (NotAfter; RFC1123)
A  expiration date (NotAfter; ISO8601)
b  effective date (NotBefore; RFC1123)
B  effective date (NotBefore; ISO8601)
d  domain name
D  all domain names (in punycode)
e  email
f  friendly name
F  effective date string (MS short date with long time)
g  signature algorithm name
G  key algorithm parameters
i  first issuer name field found (of simple, email, UPN, DNS, SAN, URL)
I  full issuer name
j  expiration date day of month (zero-padded to two digits)
J  effective date day of month (zero-padded to two digits)
k  key usages
K  extended key usages
m  expiration date month (three letter abbreviation)
M  effective date month (three letter abbreviation)
n  first short name field found (of friendly, simple, email, UPN, DNS, SAN, URL, thumbprint)
N  serial number
o  @ when the certificate is marked to send as a trusted issuer (otherwise a space)
O  [SendAsTrustedIssuer] when the certificate is marked to send as a trusted issuer
p  * when a private key is present (otherwise a space)
P  [HasPrivateKey] when a private key is present
q  same as n, but with each non-word character sequence replaced by an underscore
r  ~ when certificate has been archived (otherwise a space)
R  [Archived] when certificate has been archived
s  subject
S  simple name
t  partial thumbprint (first six digits)
T  thumbprint (SHA1 hash)
u  user principal name
U  URL name
v  version
w  expiration date day of week (three letter abbreviation)
W  effective date day of week (three letter abbreviation)
x  expiration date string (MS short date with long time)
y  expiration date year
Y  effective date year
\  escape character

.INPUTS
System.Security.Cryptography.X509Certificates.X509Certificate2 to format.

.OUTPUTS
System.String of the formatted certificate.

.LINK
https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509certificate2.aspx

.EXAMPLE
Format-Certificate.ps1 $cert

0CAD75*  example-cert-name, expires Sat, 13 Mar 2021 11:31:30 GMT

.EXAMPLE
Format-Certificate.ps1 $cert -Format 'n P T A r'

example-cert-name [HasPrivateKey] 0CAD7530A40BD2F7160B19DA77A3FCF7CAEB08D0 2021-03-13T11:31:30
#>

[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,ValueFromPipeline=$true)][Security.Cryptography.X509Certificates.X509Certificate2] $Certificate,
[Alias('Template')][string] $Format = 'tpr n, \e\x\p\i\r\e\s a'
)
Begin
{
    [bool] $Script:escape = $false
    [int[]] $Script:nameinfos = [enum]::GetValues([Security.Cryptography.X509Certificates.X509NameType])
}
Process
{
    function Get-FormatValue([char]$c)
    {
        if($Script:escape) {$Script:escape = $false; return $c}
        switch -CaseSensitive -Exact ($c)
        {
            a {Get-Date $Certificate.NotAfter -Format r}
            A {Get-Date $Certificate.NotAfter -Format s}
            b {Get-Date $Certificate.NotBefore -Format r}
            B {Get-Date $Certificate.NotBefore -Format s}
            d {$Certificate.GetNameInfo('DnsName',$false)}
            D {$Certificate.DnsNameList.Punycode -join ', '}
            e {$Certificate.GetNameInfo('EmailName',$false)}
            f {$Certificate.FriendlyName}
            F {$Certificate.GetEffectiveDateString()}
            g {$Certificate.SignatureAlgorithm.FriendlyName}
            G {$Certificate.GetKeyAlgorithmParametersString()}
            i {$Script:nameinfos |? {$Certificate.GetNameInfo($_,$true)} |select -f 1}
            I {$Certificate.Issuer}
            j {'{0:00}' -f $Certificate.NotAfter.Day}
            J {'{0:00}' -f $Certificate.NotBefore.Day}
            k {$Certificate.Extensions['2.5.29.15'].KeyUsages.ToString()}
            K {$Certificate.EnhancedKeyUsageList.FriendlyName -join ', '}
            m {'{0:00}' -f $Certificate.NotAfter.Month}
            M {'{0:00}' -f $Certificate.NotBefore.Month}
            n {@($Certificate.FriendlyName)+
                @($Script:nameinfos |% {$Certificate.GetNameInfo($_,$false)})+
                @($Certificate.Thumbprint) |? {$_} |select -f 1}
            N {$Certificate.GetSerialNumberString()}
            o {if($Certificate.SendAsTrustedIssuer){'@'}else{' '}}
            O {if($Certificate.SendAsTrustedIssuer){'[SendAsTrustedIssuer]'}}
            p {if($Certificate.HasPrivateKey){'*'}else{' '}}
            P {if($Certificate.HasPrivateKey){'[HasPrivateKey]'}}
            q {@($Certificate.FriendlyName)+
                @($Script:nameinfos |% {$Certificate.GetNameInfo($_,$false)})+
                @($Certificate.Thumbprint) |? {$_} |select -f 1 |% {$_ -replace '\W+','_'}}
            r {if($Certificate.Archived){'~'}else{' '}}
            R {if($Certificate.Archived){'[Archived]'}}
            s {$Certificate.Subject}
            S {$Certificate.GetNameInfo('SimpleName',$false)}
            t {$Certificate.Thumbprint.Substring(0,6)}
            T {$Certificate.Thumbprint}
            u {$Certificate.GetNameInfo('UpnName',$false)}
            U {$Certificate.GetNameInfo('UrlName',$false)}
            v {$Certificate.Version}
            w {$Certificate.NotAfter.DayOfWeek.ToString().Substring(0,3)}
            W {$Certificate.NotBefore.DayOfWeek.ToString().Substring(0,3)}
            x {$Certificate.GetExpirationDateString()}
            y {$Certificate.NotAfter.Year}
            Y {$Certificate.NotBefore.Year}
            '\' {$Script:escape = $true}
            default {$c}
        }
    }
    (($Format.GetEnumerator() |% {Get-FormatValue $_}) -join '').Trim()
}
