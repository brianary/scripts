<#
.Synopsis
    Enumerates the SSL protocols that the client is able to successfully use to connect to a server.

.Parameter ComputerName
    The name of the remote computer to connect to.

.Parameter Port
    The remote port to connect to.

.Example
    Test-SslProtocols -ComputerName "www.google.com"

    ComputerName       : www.google.com
    Port               : 443
    KeyLength          : 2048
    SignatureAlgorithm : rsa-sha1
    Ssl2               : False
    Ssl3               : True
    Tls                : True
    Tls11              : True
    Tls12              : True
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
[Alias('CN','Hostname')][string]$ComputerName,
[Parameter(ValueFromPipelineByPropertyName=$true)][int]$Port = 443
)
Begin {$protocols = Get-EnumValues.ps1 Security.Authentication.SslProtocols |? Name -notin 'None','Default' |% Name}
Process
{
    $result = [ordered]@{
        ComputerName       = $ComputerName
        Port               = $Port
        KeyLength          = $null
        SignatureAlgorithm = $null
        CertificateIssuer  = $null
        CertificateExpires = $null
        Certificate        = $null
    }
    foreach($protocol in $protocols)
    {
        $socket = New-Object Net.Sockets.Socket Stream,Tcp
        $socket.Connect($ComputerName,$Port)
        try
        {
            $ssl = New-Object Net.Security.SslStream (New-Object Net.Sockets.NetworkStream $socket,$true),$true
            $ssl.AuthenticateAsClient($ComputerName,$null,$protocol,$false)
            if(!$result['Certificate'])
            {
                [Security.Cryptography.X509Certificates.X509Certificate2]$cert = $ssl.RemoteCertificate
                $result['KeyLength'] = $cert.PublicKey.Key.KeySize
                $result['SignatureAlgorithm'] = $cert.SignatureAlgorithm.FriendlyName
                $result['CertificateIssuer'] = $cert.GetNameInfo('SimpleName', $true)
                $result['CertificateExpires'] = [datetime]$cert.GetExpirationDateString()
                $result['Certificate'] = $cert
            }
            $result[$protocol] = $true
        }
        catch
        {
            $result[$protocol] = $false
        }
        finally
        {
            $ssl.Close()
        }
    }
    [pscustomobject]$result
}
