<#
.Synopsis
    Exports web server settings, shares, and installed MSAs.

.Link
    https://chocolatey.org/

.Link
    Export-WebConfiguration.ps1

.Link
    Export-SmbShare.ps1

.Example
    Export-WebServer.ps1

    Exports server settings as PowerShell scripts.
#>

#Requires -RunAsAdministrator
[CmdletBinding()] Param(
[string]$Path = "Import-${env:ComputerName}.ps1"
)

function Test-Administrator
{
    ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
        IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Export-Header
{
    Write-Verbose "Creating export script $Path"
    @"
<#
.Synopsis
    Imports web server settings, shares, and installed MSAs exported from ${env:ComputerName}.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
#Requires -Module ActiveDirectory
[CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()

"@
}

function Export-WebConfiguration
{
    if(!(Get-Module WebAdministration -ListAvailable)){Write-Warning "IIS not detected. Skipping."; return}
    Write-Verbose "Exporting web configuration to $Path"
    Export-WebConfiguration.ps1
    @"

function Import-WebConfiguration
{
    [CmdletBinding()] Param()
    Write-Verbose 'Importing web configuration.'
    if(Test-Path 'Import-${env:ComputerName}WebConfiguration.ps1' -PathType Leaf)
    {Import-${env:ComputerName}WebConfiguration.ps1}
    elseif(Test-Path "`$PSScriptRoot\Import-${env:ComputerName}WebConfiguration.ps1" -PathType Leaf)
    {& "`$PSScriptRoot\Import-${env:ComputerName}WebConfiguration.ps1"}
    else
    {throw 'Could not find Import-${env:ComputerName}WebConfiguration.ps1'}
}
"@
}

function Export-SmbShares
{
    Write-Verbose "Exporting SMB shares to $Path"
    Export-SmbShares.ps1
    @"

function Import-SmbShares
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('SMB shares','create')){return}
    Write-Verbose 'Importing SMB shares.'
    if(Test-Path 'Import-${env:ComputerName}SmbShares.ps1' -PathType Leaf)
    {Import-${env:ComputerName}SmbShares.ps1}
    elseif(Test-Path "`$PSScriptRoot\Import-${env:ComputerName}SmbShares.ps1" -PathType Leaf)
    {& "`$PSScriptRoot\Import-${env:ComputerName}SmbShares.ps1"}
    else
    {throw 'Could not find Import-${env:ComputerName}SmbShares.ps1'}
}
"@
}

function Export-Hosts
{
    if(!(Get-Content $env:SystemRoot\system32\drivers\etc\hosts |Select-String '^\s*\d')){return}
    Write-Verbose "Copying hosts file to $PSScriptRoot"
    Copy-Item $env:SystemRoot\system32\drivers\etc\hosts $PSScriptRoot
    @'

function Import-Hosts
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('hosts file','replace')){return}
    Write-Verbose 'Updating hosts file'
    Move-Item $env:SystemRoot\system32\drivers\etc\hosts $env:SystemRoot\system32\drivers\etc\hosts.$(Get-Date -f yyyyMMddHHmmss)
    Copy-Item $PSScriptRoot\hosts $env:SystemRoot\system32\drivers\etc\hosts
}
'@
}

function Export-SystemDsns
{
    if(!(Get-ChildItem HKLM:\SOFTWARE\ODBC\ODBC.INI\*)){return}
    Write-Verbose "Exporting ODBC system DSNs to $PSScriptRoot"
    regedit /e "$PSScriptRoot\ODBC.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI"
    @'

function Import-SystemDsns
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('ODBC system DSNs','import')){return}
    Write-Verbose 'Import ODBC system DSNs'
    regedit "$PSScriptRoot\ODBC.reg"
}
'@
}

function Export-FileDsns
{
    if(!(Test-Path "$env:CommonProgramFiles\ODBC\Data Sources\*.dsn" -PathType Leaf)){return}
    Write-Verbose "Copying ODBC DSN files to $PSScriptRoot"
    Copy-Item "$env:CommonProgramFiles\ODBC\Data Sources\*.dsn" $PSScriptRoot
    @'

function Import-FileDsns
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('ODBC DSN files','copy')){return}
    Write-Verbose 'Copying ODBC DSN files'
    mkdir "$env:CommonProgramFiles\ODBC\Data Sources"
    Copy-Item $PSScriptRoot\*.dsn "$env:CommonProgramFiles\ODBC\Data Sources"
}
'@
}

function Export-Msas
{
    Write-Verbose "Creating import/conversion for MSAs in $Path"
    @"

function Import-Msas
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('MSAs','rebind')){return}
    Write-Verbose 'Rebinding managed service accounts.'
    Get-ADServiceAccount -Filter * |
        ? HostComputers -contains "`$(Get-ADComputer '${env:ComputerName}' |% DistinguishedName)" |
        Install-ADServiceAccount
}
"@
}

function Export-ChocolateyPackages
{
    Write-Verbose "Exporting list of installed Chocolatey packages to $Path"
    $cinst = clist -lr |
        select -Skip 1 |
        % {
            $pkg,$ver = $_ -split '\|',2
            "if(`$PSCmdlet.ShouldProcess('$($pkg -replace "'","''")','install')) {cinst $pkg -y} # $ver"
        }
    @"

function Import-ChocolateyPackages
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('chocolatey packages','install')){return}
    $($cinst -join "`r`n    ")
}
"@
}

function Export-WebPlatformInstallerPackages
{
    if(!(Get-Command webpicmd -CommandType Application -ErrorAction SilentlyContinue)){return}
    Write-Verbose "Exporting list of installed WebPI packages to $Path"
    $webpicmd = webpicmd /list /listoption:installed |
        ? {![string]::IsNullOrWhiteSpace($_)} | #TODO: FIX: Not working right on all machines yet
        select -skip 9 |
        % {
            $id,$title = $_ -split '\s+',2
            "if(`$PSCmdlet.ShouldProcess('$($id -replace "'","''")','install')) {webpicmd /install /products:$id} # $title"
        }
    @"

function Import-WebPlatformInstallerPackages
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('chocolatey packages','install')){return}
    $($webpicmd -join "`r`n    ")
}
"@
}

function Export-InstalledApplications
{
    #TODO: Write InstalledApplications.txt using WMI Programs (excluding MS)
}

function Export-Footer
{
    Write-Verbose "Finishing export to $Path"
    @"

Import-WebConfiguration
Import-SmbShares
Import-Hosts
Import-SystemDsns
Import-FileDsns
Import-Msas
Import-ChocolateyPackages
Import-WebPlatformInstallerPackages
"@
}

function Export-Server
{
    if(!(Test-Administrator)) {throw 'This script must be run as administrator.'}
    Export-Header
    Export-WebConfiguration
    Export-SmbShares
    Export-Hosts
    Export-SystemDsns
    Export-FileDsns
    Export-Msas
    Export-ChocolateyPackages
    Export-WebPlatformInstallerPackages
    Export-Footer
}

Export-Server |Out-File "Import-${env:ComputerName}.ps1" utf8
