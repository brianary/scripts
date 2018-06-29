<#
.Synopsis
    Gets the physical path on disk of a certificate.

.Parameter Certificate
    The X509Certificate2 to look up the path for.

.Inputs
    System.Security.Cryptography.X509Certificates.X509Certificate2 to find the private key file for.

.Outputs
    System.String of the path to the private key file (if found).

.Link
    Find-Certificate.ps1

.Example
    Find-Certificate.ps1 localhost FindBySubjectName My LocalMachine |Get-CertificatePath.ps1

    C:\ProgramData\Microsoft\crypto\rsa\machinekeys\abd662b361941f26a1173357adb3c12d_b4d34fe9-d85e-45e3-83dd-a52fa93c8551
#>

#Requires -Version 3
#TODO: Require version 4 to get access to Get-ChildItem -Directory switch param
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
Process
{
    [bool]$hasPath = $Certificate |Get-Member Path -MemberType Property
    if($hasPath -and $Certificate.Path) {$Certificate.Path}
    else
    {
        $file = $Certificate.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
        Write-Verbose "Certificate file: $file"
        $path = "$env:ProgramData\Microsoft\crypto\rsa\machinekeys\$file"
        if(!(Test-Path $path -PathType Leaf))
        {
            Write-Verbose "Machine key path not found: $path"
            $sid = ([Security.Principal.NTAccount]$env:USERNAME).Translate([Security.Principal.SecurityIdentifier]).Value
            $path = "$env:APPDATA\Microsoft\Crypto\RSA\$sid\$file"
            if(!(Test-Path $path -PathType Leaf))
            { # flail wildly
                Write-Warning "Searching more desperately for the certificate file."
                $path = Get-ChildItem $env:USERPROFILE\.. |
                    ? {$_ -is [IO.DirectoryInfo]} |
                    % {"$($_.FullName)\AppData\Roaming\Microsoft\Crypto\RSA"} |
                    ? {Test-Path $_ -PathType Container} |
                    Get-ChildItem |
                    ? {$_ -is [IO.DirectoryInfo]} |
                    % {Join-Path $_.FullName $file} |
                    ? {Test-Path $_ -PathType Leaf}
            }
            if(!(Test-Path $path -PathType Leaf)) {throw "Could not find certificate path: $path"}
        }
        Write-Verbose "Certificate path: $path"
        if($hasPath) {$Certificate.Path = $path}
        else {Add-Member -InputObject $Certificate -MemberType NoteProperty -Name Path -Value $path}
        $path
    }
}
