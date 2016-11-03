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

    Starting after version 13.0.1601.5, the SqlServer module is installed with SSMS 2016 16.4.1.
    This puts the SqlServer module in C:\Program Files\WindowsPowerShell\Modules,
    which may need to be prepended to the PSModulePath environment variable after
    installation.

.Link
    Start-Process

.Link
    Invoke-WebRequest

.Link
    Get-Module

.Link
    Import-Module

.Link
    https://msdn.microsoft.com/library/mt238290.aspx

.Example
    Install-SqlServerModule.ps1


    Removes old SQLPS modules and installs the latest, as needed.
#>

#requires -version 3
#requires -RunAsAdministrator
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)]Param(
[version]$Version = '13.0.16000.28',
[uri]$SsmsDownload = 'https://download.microsoft.com/download/C/B/C/CBCFAAD1-2348-4119-B093-199EE7AADCBC/SSMS-Setup-ENU.exe'
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
}

function Install-NewSqlServerModule
{
    $modulesdir = "$env:ProgramFiles\WindowsPowerShell\Modules"
    if(Test-Path $modulesdir\SqlServer -PathType Container)
    {
        $installedversion = Get-ChildItem $modulesdir\SqlServer\Microsoft.SqlServer.Management.PSSnapins.dll |% VersionInfo |% FileVersion
        if($installedversion -ge $Version)
        {
            Write-Host "You already have the latest SqlServer module." -ForegroundColor Green -BackgroundColor DarkMagenta
            return
        }
    }
    if(!($PSCmdlet.ShouldProcess(${setup.exe},'Install'))) {return}
    ${setup.exe} = Join-Path $env:TEMP ($SsmsDownload.Segments |select -Last 1)
    Invoke-WebRequest $SsmsDownload.AbsoluteUri -OutFile ${setup.exe}
    Start-Process ${setup.exe} '/install','/passive' -NoNewWindow -Wait
    [Environment]::SetEnvironmentVariable('PSModulePath',
        $modulesdir +';'+ [Environment]::GetEnvironmentVariable('PSModulePath','Machine'))
    Import-Module SqlServer
}

Remove-AnyOldModule
Install-NewSqlServerModule
