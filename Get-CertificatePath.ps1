<#
.Synopsis
    Gets the physical path on disk of a certificate.

.Parameter Certificate
    The X509Certificate2 to look up the path for.
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
Process
{
    if($Certificate.PSObject.Properties.Match('Path')) {$Certificate.Path}
    else
    {
        $file = $Certificate.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
        Write-Verbose "Certificate file: $file"
        $path = "$env:ProgramData\Microsoft\crypto\rsa\machinekeys\$file"
        if(!(Test-Path $path -PathType Leaf))
        {
            $sid = ([Security.Principal.NTAccount]$env:USERNAME).Translate([Security.Principal.SecurityIdentifier]).Value
            $path = "$env:APPDATA\Roaming\Microsoft\Crypto\RSA\$sid\$file"
        }
        Write-Verbose "Certificate path: $path"
        Add-Member -InputObject $Certificate -MemberType ScriptProperty -Name Path -Value {$path}
        $path
    }
}