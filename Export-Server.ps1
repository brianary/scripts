<#
.Synopsis
    Exports web server settings, shares, ODBC DSNs, and installed MSAs as PowerShell scripts and data.

.Parameter Path
    The path of the script to create.

.Link
    https://chocolatey.org/

.Link
    Export-WebConfiguration.ps1

.Link
    Export-SmbShare.ps1

.Example
    Export-WebServer.ps1

    Exports server settings as PowerShell scripts and data, including any of:

    - An editable script specified by the Path parameter (Import-${env:ComputerName}.ps1 by default)
    - Import-${env:ComputerName}WebConfiguration.ps1 for IIS settings
    - Import-${env:ComputerName}SmbShares.ps1 for Windows file shares
    - hosts containing customized hosts file entries
    - ODBC.reg containing ODBC system DSNs
    - *.dsn, each an ODBC file DSN found in the default file DSN path ${env:CommonProgramFiles}\ODBC\Data Sources
    - InstalledApplications.txt containing a list of non-Microsoft applications in "Programs and Features"
      (Add/Remove Programs in older Windows versions)
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
    {Write-Warning 'Could not find Import-${env:ComputerName}WebConfiguration.ps1, skipping web configuration import.'}
}
"@
    if(!(Get-Module WebAdministration -ListAvailable)){Write-Warning "IIS not detected. Skipping."; return}
    Write-Verbose "Exporting web configuration to $Path"
    Export-WebConfiguration.ps1
}

function Export-SmbShares
{
    @"

function Import-SmbShares
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('SMB shares','create')) {return}
    Write-Verbose 'Importing SMB shares.'
    if(Test-Path 'Import-${env:ComputerName}SmbShares.ps1' -PathType Leaf)
    {Import-${env:ComputerName}SmbShares.ps1}
    elseif(Test-Path "`$PSScriptRoot\Import-${env:ComputerName}SmbShares.ps1" -PathType Leaf)
    {& "`$PSScriptRoot\Import-${env:ComputerName}SmbShares.ps1"}
    else
    {Write-Warning 'Could not find Import-${env:ComputerName}SmbShares.ps1, skipping shares import.'}
}
"@
    Write-Verbose "Exporting SMB shares to $Path"
    Export-SmbShares.ps1
}

function Export-Hosts
{
    @'

function Import-Hosts
{
    [CmdletBinding(SupportsShouldProcess=$true)] Param()
    if(!(Test-Path $PSScriptRoot\hosts -PathType Leaf)) {return}
    if(!$PSCmdlet.ShouldProcess('hosts file','replace')) {return}
    Write-Verbose 'Updating hosts file'
    Move-Item $env:SystemRoot\system32\drivers\etc\hosts $env:SystemRoot\system32\drivers\etc\hosts.$(Get-Date -f yyyyMMddHHmmss)
    Copy-Item $PSScriptRoot\hosts $env:SystemRoot\system32\drivers\etc\hosts
}
'@
    if(!(Get-Content $env:SystemRoot\system32\drivers\etc\hosts |Select-String '^\s*\d')){return}
    Write-Verbose "Copying hosts file to $PSScriptRoot"
    Copy-Item $env:SystemRoot\system32\drivers\etc\hosts $PSScriptRoot
}

function Export-SystemDsns
{
    @'

function Import-SystemDsns
{
    [CmdletBinding(SupportsShouldProcess=$true)] Param()
    if(!(Test-Path $PSScriptRoot\ODBC.reg)) {return}
    if(!$PSCmdlet.ShouldProcess('ODBC system DSNs','import')) {return}
    Write-Verbose 'Import ODBC system DSNs'
    regedit $PSScriptRoot\ODBC.reg
}
'@
    if(!(Get-ChildItem HKLM:\SOFTWARE\ODBC\ODBC.INI\*)){return}
    Write-Verbose "Exporting ODBC system DSNs to $PSScriptRoot"
    regedit /e "$PSScriptRoot\ODBC.reg" "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI"
}

function Export-FileDsns
{
    @'

function Import-FileDsns
{
    [CmdletBinding(SupportsShouldProcess=$true)] Param()
    if(!(Get-Item $PSScriptRoot\*.dsn)) {return}
    if(!$PSCmdlet.ShouldProcess('ODBC DSN files','copy')) {return}
    Write-Verbose 'Copying ODBC DSN files'
    mkdir "$env:CommonProgramFiles\ODBC\Data Sources"
    Copy-Item $PSScriptRoot\*.dsn "$env:CommonProgramFiles\ODBC\Data Sources"
}
'@
    if(!(Test-Path "$env:CommonProgramFiles\ODBC\Data Sources\*.dsn" -PathType Leaf)){return}
    Write-Verbose "Copying ODBC DSN files to $PSScriptRoot"
    Copy-Item "$env:CommonProgramFiles\ODBC\Data Sources\*.dsn" $PSScriptRoot
}

function Export-Msas
{
    @"

function Import-Msas
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('MSAs','rebind')) {return}
    Write-Verbose 'Rebinding managed service accounts.'
    Get-ADServiceAccount -Filter * |
        Where-Object HostComputers -contains "`$(Get-ADComputer '${env:ComputerName}' |ForEach-Object DistinguishedName)" |
        Install-ADServiceAccount
}
"@
    Write-Verbose "Created import/conversion for MSAs in $Path"
}

function Export-ChocolateyPackages
{
    Write-Verbose "Exporting list of installed Chocolatey packages to $Path"
    $cinst =
        if(!(Get-Command clist -CommandType Application -ErrorAction SilentlyContinue)) {@()}
        else
        {
            clist -lr |
                Select-Object -Skip 1 |
                ForEach-Object {
                    $pkg,$ver = $_ -split '\|',2
                    "if(`$PSCmdlet.ShouldProcess('$($pkg -replace "'","''")','install')) {cinst $pkg -y} # $ver"
                }
        }
    @"

function Import-ChocolateyPackages
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('$($cinst.Count) chocolatey packages','install')) {return}
    $($cinst -join "`r`n    ")
}
"@
}

function Export-WebPlatformInstallerPackages
{
    Write-Verbose "Exporting list of installed WebPI packages to $Path"
    $webpicmd =
        if(!(Get-Command webpicmd -CommandType Application -ErrorAction SilentlyContinue)) {@()}
        else
        {
            $webpiout = webpicmd /list /listoption:installed |
                Where-Object {![string]::IsNullOrWhiteSpace($_)}
            for($i = 0; $i -lt $webpiout.Count; $i++)
            { if($webpiout[$i].Trim() -eq '----------------------------------------') {break} }
            (++$i)..($webpiout.Count -1) |
                ForEach-Object {
                    $id,$title = $webpiout[$_] -split '\s+',2
                    "if(`$PSCmdlet.ShouldProcess('$($id -replace "'","''")','install')) {webpicmd /install /products:$id} # $title"
                }
        }
    @"

function Import-WebPlatformInstallerPackages
{
    [CmdletBinding(SupportsShouldProcess=`$true)] Param()
    if(!`$PSCmdlet.ShouldProcess('$($webpicmd.Count) web platform installer packages','install')) {return}
    $($webpicmd -join "`r`n    ")
}
"@
}

function Export-InstalledApplications
{
    Write-Verbose "Exporting list of installed applications to InstalledApplications.txt"
    Get-WmiObject Win32_Product -Filter "Vendor <> 'Microsoft Corporation'" |
        Sort-Object Caption |
        ForEach-Object {"$($_.Caption) ($($_.Version))"} |
        Out-File InstalledApplications.txt utf8
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
    Export-InstalledApplications
}

Export-Server |Out-File "Import-${env:ComputerName}.ps1" utf8
