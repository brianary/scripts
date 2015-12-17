<#
.Synopsis
    Returns HTTPS certificate expiration and other cert info for a host.
    
.Parameter HostName
    A list of hostnames to check the expiration dates of.
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
        New-Object PSObject -Property @{
            Host    = $h
            Subject = $cert.GetNameInfo('SimpleName', $false)
            Expires = [datetime]::Parse($cert.GetExpirationDateString())
            Issuer  = $cert.GetNameInfo('SimpleName', $true)
            KeySize = $cert.PublicKey.Key.KeySize
            SignatureAlgorithm = $cert.SignatureAlgorithm.FriendlyName
        }
    }
}
