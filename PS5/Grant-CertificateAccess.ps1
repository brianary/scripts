<#
.SYNOPSIS
Grants certificate file read access to an app pool or user.

.PARAMETER AppPool
The name of the application pool to grant access.

.PARAMETER UserName
The username to grant access to.

.PARAMETER Certificate
The certificate to grant access to.

.INPUTS
System.Security.Cryptography.X509Certificates.X509Certificate2 to grant permissions to
the private key file of.

.LINK
Get-Acl

.LINK
Set-Acl

.LINK
Get-Command

.LINK
Find-Certificate.ps1

.LINK
Get-CertificatePath.ps1

.LINK
Get-CertificatePermissions.ps1

.LINK
Show-CertificatePermissions.ps1

.LINK
https://msdn.microsoft.com/library/sacxhfka.aspx

.LINK
http://stackoverflow.com/a/21713869/54323

.LINK
https://technet.microsoft.com/library/ee909471.aspx

.EXAMPLE
Grant-CertificateAccess.ps1 -AppPool ExampleAppPool -Certificate $cert

Grants the ExampleAppPool app pool access to read the cert in $cert.

.EXAMPLE
Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Grant-CertificateAccess.ps1 ExampleAppPool

Grants the ExampleAppPool app pool access to read the found ExampleCert.

For more information about options for -FindType:
https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx
#>

#Requires -Version 3
#TODO: require admin formally once everything is > PowerShell 3
#-Requires -RunAsAdministrator
# WebAdministration is conditionally imported below, since it's only needed for AppPools.
#-Requires -Module WebAdministration
[CmdletBinding(ConfirmImpact='Medium',SupportsShouldProcess=$true)][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true,ParameterSetName='AppPool')]
[string]$AppPool,
[Parameter(Position=0,Mandatory=$true,ParameterSetName='UserName')]
[string]$UserName,
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
Begin
{
    try{Get-Command Get-Acl -CommandType Cmdlet |Out-Null}catch{throw 'The Get-Acl command is missing.'}
    if($AppPool){Import-Module WebAdministration; if(!(Test-Path IIS:\AppPools\$AppPool)){throw "Could not find IIS:\AppPools\$AppPool"}}

    # ensure admins have access to grant access to machinekeys
    $machinekeys = "$env:ProgramData\Microsoft\crypto\rsa\machinekeys"
    $acl = Get-Acl $machinekeys
    if(!($acl.Access |? {$_.IdentityReference -eq 'BUILTIN\Administrators' -and $_.FileSystemRights -eq 'FullControl'}) -and
        $PSCmdlet.ShouldProcess($machinekeys,'grant Administrators full control'))
    {
        if($acl.GetOwner([Security.Principal.NTAccount]) -ne 'BUILTIN\Administrators' -and
            $PSCmdlet.ShouldProcess($machinekeys,'set Administrators as owner'))
        {
            Write-Verbose "Preparing to make Administrators owner of $machinekeys"
            $acl.SetOwner([Security.Principal.NTAccount]'BUILTIN\Administrators')
        }
        $acl.SetAccessRule((New-Object Security.AccessControl.FileSystemAccessRule 'BUILTIN\Administrators','FullControl','Allow'))
        Write-Verbose "Granting Administrators full access to $machinekeys"
        Set-Acl $machinekeys $acl
    }
}
Process
{
    if($AppPool) {$UserName="IIS AppPool\${AppPool}"}
    elseif($UserName -notlike '*\*') {$UserName = "$env:USERDOMAIN\$UserName"}
    $path = Get-CertificatePath.ps1 $Certificate
    if(!$PSCmdlet.ShouldProcess($path,"grant read access for $UserName")){return}
    Write-Verbose "Granting $UserName read access to $path"
    $acl = Get-Acl $path
    $acl.SetAccessRule((New-Object Security.AccessControl.FileSystemAccessRule $UserName,'Read','Allow'))
    Set-Acl $path $acl
    Show-CertificatePermissions.ps1 $Certificate
}
