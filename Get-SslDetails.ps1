<#
.SYNOPSIS
Enumerates the SSL protocols that the client is able to successfully use to connect to a server.

.INPUTS
System.String of hostname(s) to get SSL support and certificate details for.

.OUTPUTS
System.Management.Automation.PSCustomObject with certifcated details and
properties indicating support for SSL protocols with the cypher algorithm used
if supported or false if not supported.

.FUNCTIONALITY
HTTP

.LINK
https://msdn.microsoft.com/library/system.security.authentication.sslprotocols.aspx

.LINK
https://msdn.microsoft.com/library/system.net.security.sslstream.authenticateasclient.aspx

.LINK
Get-EnumValues.ps1

.EXAMPLE
Get-SslDetails.ps1 -ComputerName www.google.com

ComputerName       : www.google.com
Port               : 443
KeyLength          : 2048
SignatureAlgorithm : rsa-sha1
CertificateIssuer  : Google Inc
CertificateExpires : 06/20/2018 06:22:00
Ssl2               : False
Ssl3               : False
Tls                : Aes128
Tls11              : Aes128
Tls12              : Aes128
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
# The name of the remote computer to connect to.
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
[Alias('CN','Hostname')][string]$ComputerName,
# The remote port to connect to.
[Parameter(ValueFromPipelineByPropertyName=$true)][int]$Port = 443
)
Begin {$protocols = Get-EnumValues.ps1 Security.Authentication.SslProtocols |? Name -notin 'None','Default' |% Name}
Process
{
    $result = [ordered]@{
        ComputerName         = $ComputerName
        Port                 = $Port
        KeyLength            = $null
        SignatureAlgorithm   = $null
        CertificateIssuer    = $null
        CertificateEffective = $null
        CertificateExpires   = $null
        Certificate          = $null
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
                $result['CertificateEffective'] = $cert.NotBefore
                $result['CertificateExpires'] = $cert.NotAfter
                $result['Certificate'] = $cert
            }
            $result[$protocol] = $ssl.CipherAlgorithm
        }
        catch
        {
            $result[$protocol] = $false
        }
        finally
        {
            if($ssl -is [IDisposable]) {$ssl.Dispose()}
            if($socket -is [IDisposable]) {$socket.Dispose()}
        }
    }
    [pscustomobject]$result
}
