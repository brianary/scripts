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
    if($Certificate.PSObject.Properties.Match('Path').Count -and $Certificate.Path) {$Certificate.Path}
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
                $path = Get-ChildItem $env:USERPROFILE\.. -Directory |
                    % {"$($_.FullName)\AppData\Roaming\Microsoft\Crypto\RSA"} |
                    ? {Test-Path $_ -PathType Container} |
                    Get-ChildItem -Directory |
                    % {Join-Path $_.FullName $file} |
                    ? {Test-Path $_ -PathType Leaf}
            }
            if(!(Test-Path $path -PathType Leaf)) {throw "Could not find certificate path: $path"}
        }
        Write-Verbose "Certificate path: $path"
        if($Certificate.PSObject.Properties.Match('Path').Count) {$Certificate.Path = $path}
        else {Add-Member -InputObject $Certificate -MemberType NoteProperty -Name Path -Value $path}
        $path
    }
}