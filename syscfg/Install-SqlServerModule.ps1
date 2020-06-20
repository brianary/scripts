<#
.Synopsis
    Installs SqlServer module and dependencies.

.Parameter Version
    The version number to install.
    Used to determine which installed versions are too old.
    Defaults to the latest.

.Parameter Source
    A file directory or base URI to download the required MSI files from.
    Defaults to the latest.

.Notes
    SQL Server Feature Pack Versions
    SQL Name      Version        Source
    2016          13.0.1601.5    https://www.microsoft.com/download/details.aspx?id=52676
    2014          12.0.2000.8    https://www.microsoft.com/download/details.aspx?id=42295
    2012          11.0.2100.60   https://www.microsoft.com/download/details.aspx?id=29065
    2008R2        10.50.1600.1   https://www.microsoft.com/download/details.aspx?id=16978
    2008sp2       10.00.4000.00  https://www.microsoft.com/download/details.aspx?id=6375
    2005/Feb2007  9.00.3042 *    https://www.microsoft.com/download/details.aspx?id=24793

    * no SqlServer module/SQLPS/SMO/SQLCLR

    SSMS 2016 16.4.1 - 16.5.3 included the first SqlServer module, replacing SQLPS.

    Starting with SSMS 2017, the SqlServer module is installed separately, using
    the "Install-Module SqlServer" command (from the PowerShellGet module).

.Link
    Install-Module

.Link
    Start-Process

.Link
    Get-Module

.Link
    Import-Module

.Link
    https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-ps-module

.Example
    Install-SqlServerModule.ps1


    Removes old SQLPS modules and installs the latest, as needed.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
#Requires -Module PowerShellGet
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)][OutputType([void])] Param(
[version]$Version = '21.0.17099'
)

function Test-OldModulePath([string]$Path)
{
    Test-Path (Join-Path $Path SQLPS\Microsoft.SqlServer.Management.PSSnapins.dll) -PathType Leaf
}

function Update-PSModulePath([EnvironmentVariableTarget]$Target)
{
    if(!$PSCmdlet.ShouldProcess("$Target PSModulePath",'Update')) {return}
    $modulepath = [Environment]::GetEnvironmentVariable('PSModulePath',$Target)
    Write-Verbose "Initial $Target PSModulePath: $modulepath"
    $modulepath = ($modulepath -split ';' |? {$_} |? {!(Test-OldModulePath $_)}) -join ';'
    Write-Verbose "Updated $Target PSModulePath: $modulepath"
    [Environment]::SetEnvironmentVariable('PSModulePath',$modulepath,$Target)
}

function Update-PSModulePathProcess
{
    Write-Verbose "Initial Process PSModulePath: $env:PSModulePath"
    $env:PSModulePath = (@([Environment]::GetEnvironmentVariable('PSModulePath','User'),
        [Environment]::GetEnvironmentVariable('PSModulePath','Machine')) |? {$_}) -join ';'
    Write-Verbose "Updated Process PSModulePath: $env:PSModulePath"
}

function Uninstall-OldModules
{
    # Win32_Product slowly reconfigures each entry, Win32Reg_AddRemovePrograms is faster
    # see https://sdmsoftware.com/group-policy-blog/wmi/why-win32_product-is-bad-news/
    # see also http://support.microsoft.com/kb/974524
    try
    {
        Get-WmiObject Win32Reg_AddRemovePrograms -Filter "DisplayName like '%PowerShell Extensions for SQL Server %'" -EA Stop |
            ? {$PSCmdlet.ShouldProcess($_.DisplayName,'Uninstall')} |
            % {Start-Process -FilePath msiexec.exe -ArgumentList '/x',$_.ProdID,'/passive','/norestart' -Wait -NoNewWindow}
    }
    catch
    {
        Get-WmiObject Win32_Product -Filter "Name like '%PowerShell Extensions for SQL Server %'" |
            ? {$PSCmdlet.ShouldProcess($_.Name,'Uninstall')} |
            % {Start-Process -FilePath msiexec.exe -ArgumentList '/x',$_.IdentifyingNumber,'/passive','/norestart' -Wait -NoNewWindow}
    }
}

function Remove-AnyOldModule
{
    if(!(Get-Module SQLPS -ListAvailable))
    { Write-Host 'Found no old SQLPS modules.' -ForegroundColor Green -BackgroundColor DarkMagenta }
    else
    {
        Write-Verbose 'Found old SQLPS modules.'
        Get-Command msiexec.exe -CommandType Application -ErrorAction Stop |Out-Null
        Remove-Module SQLPS -ErrorAction SilentlyContinue
        Uninstall-OldModules
        Update-PSModulePath User
        Update-PSModulePath Machine
        Update-PSModulePathProcess
    }
    if(!(Get-Module SqlServer -ListAvailable |? Version -lt $Version))
    { Write-Host 'Found no old SqlServer modules.' -ForegroundColor Green -BackgroundColor DarkMagenta }
    else
    {
        Write-Host 'Found old SqlServer modules.' -ForegroundColor Green -BackgroundColor DarkMagenta
        Get-Module SqlServer -ListAvailable |? Version -lt $Version |Remove-Module -Verbose
    }
}

function Install-NewSqlServerModule
{
    if(Get-Module SqlServer -ListAvailable |? Version -ge $Version)
    {
        Get-Module SqlServer -ListAvailable |
            ? Version -ge $Version |
            select -Unique -ExpandProperty Version |
            % {Write-Host "SqlServer version $_ already installed." -ForegroundColor Green -BackgroundColor DarkMagenta}
    }
    else
    {
        Write-Host "Installing SqlServer" -ForegroundColor Green -BackgroundColor DarkMagenta
        Install-Module SqlServer -Scope AllUsers
    }
}

Remove-AnyOldModule
Install-NewSqlServerModule
