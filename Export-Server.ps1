<#
.Synopsis
    Exports web server settings, shares, and installed MSAs.

.Example
    Export-WebServer.ps1

    Exports server settings as PowerShell scripts.
#>

#Requires -RunAsAdministrator
[CmdletBinding()] Param(
[string]$Path = "Import-${env:ComputerName}.ps1"
)

function Export-Header
{
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
    Export-SmbShares.ps1
    @"

function Import-SmbShares
{
    [CmdletBinding()] Param()
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
    Copy-Item $env:SystemRoot\system32\drivers\etc\hosts $PSScriptRoot
    @'

function Import-Hosts
{
    [CmdletBinding()] Param()
    if(!`$PSCmdlet.ShouldProcess('hosts file','replace')){return}
    Write-Verbose 'Updating hosts file'
    Move-Item $env:SystemRoot\system32\drivers\etc\hosts $env:SystemRoot\system32\drivers\etc\hosts.$(Get-Date -f yyyyMMddHHmmss)
    Copy-Item $PSScriptRoot\hosts $env:SystemRoot\system32\drivers\etc\hosts
}
'@
}

function Export-Msas
{
    @"

function Import-Msas
{
    [CmdletBinding()] Param()
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
    $Local:OFS = "`r`n    "
    @"

function Import-ChocolateyPackages
{
    [CmdletBinding()] Param()
    if(!`$PSCmdlet.ShouldProcess('chocolatey packages','install')){return}
    $(clist -lr |% {$pkg,$ver = $_ -split '\|',2; "if(`$PSCmdlet.ShouldProcess('$($pkg -replace "'","''")','install')) {cinst $pkg -y # $ver}"})
}
"@
}

function Export-Footer
{
    @"

Import-WebConfiguration
Import-SmbShares
Import-Hosts
Import-Msas
Import-ChocolateyPackages
"@
}

Export-Server
{
    Export-Header
    Export-WebConfiguration
    Export-SmbShares
    Export-Hosts
    #TODO: file DNSs, WebPI/Windows modules (AzMan?)
    Export-Msas
    Export-ChocolateyPackages
    Export-Footer
}

Export-Server |Out-File "Import-${env:ComputerName}.ps1" utf8
