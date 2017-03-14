<#
.Synopsis
    Returns HTTPS certificate expiration and other cert info for a host.
    
.Parameter HostName
    A list of hostnames to check the expiration dates of.

.Example
    Get-CertificateExpiration.ps1 www.example.com web.example.org

    Host               : www.example.com
    Expires            : 12/06/2019 11:05:20
    Subject            : www.example.com
    Issuer             : Let's Encrypt
    KeySize            : 2048
    SignatureAlgorithm : sha256RSA

    Host               : web.example.org
    Expires            : 01/30/2019 04:00:00
    Subject            : web.example.org
    Issuer             : TrustCo SHA2 Extended Validation Server CA
    KeySize            : 2048
    SignatureAlgorithm : sha256RSA
#>
[CmdletBinding()]Param(
[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)]
[string[]]$HostName
)
Process 
{
    foreach( $h in $HostName )
    {
        $h = $h.Trim()
        Write-Verbose $h
        $req = [Net.HttpWebRequest]::Create("https://$h/")
        $req.Method = 'HEAD'
        try{Write-Verbose $req.GetResponse()}catch{}
        $cert = [Security.Cryptography.X509Certificates.X509Certificate2]$req.ServicePoint.Certificate
        if(!$cert) { Write-Error "Could not connect to $h" ; continue }
        New-Object PSObject -Property ([ordered]@{
            Host    = $h
            Subject = $cert.GetNameInfo('SimpleName', $false)
            Expires = [datetime]::Parse($cert.GetExpirationDateString())
            Issuer  = $cert.GetNameInfo('SimpleName', $true)
            KeySize = $cert.PublicKey.Key.KeySize
            SignatureAlgorithm = $cert.SignatureAlgorithm.FriendlyName
        })
    }
}
