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

    Starting with version 13.0.15900.1, the module is installed with SSMS 2016 16.4.1.
    This puts the SqlServer module in C:\Program Files\WindowsPowerShell\Modules,
    which may need to be prepended to the PSModulePath environment variable after
    installation. (This is not yet automated.)

.Link
    Start-Process

.Link
    Invoke-WebRequest

.Link
    Import-Module

.Link
    https://www.microsoft.com/download/details.aspx?id=52676

.Link
    https://msdn.microsoft.com/library/mt238290.aspx

.Example
    Install-SqlServerModule.ps1


    Removes old versions and installs the latest, as needed.

.Example
    Install-SqlServerModule.ps1 -Source $env:USERPROFILE\Downloads


    Uses already downloaded versions of the installers.
#>

#requires -version 3
#requires -RunAsAdministrator
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)]Param(
[version]$Version = '13.0.1601.5',
[uri]$Source = 'https://download.microsoft.com/download/8/7/2/872BCECA-C849-4B40-8EBE-21D48CDF1456/ENU/x64/'
)

function Test-WrongSnapin([IO.FileInfo]$Path)
{
    $old = 
        if($Version -gt [version]$Path.VersionInfo.ProductVersion) {$true}
        elseif(!([Environment]::Is64BitProcess)) {$false} # 32-bit PowerShell, don't check bits
        else {$Path.FullName.StartsWith((Join-Path ${env:ProgramFiles(x86)} ''))} # 32-bit vs. 64-bit PS
    Write-Verbose "'$Path' old? $old"
    $old
}

function Test-OldModule([Management.Automation.PSModuleInfo]$module)
{
    Join-Path $module.Path ..\Microsoft.SqlServer.Management.PSSnapins.dll |
        Get-ChildItem |
        % {Test-WrongSnapin $_.FullName}
}

function Test-OldModulePath([string]$Path)
{
    $snapin = Join-Path $Path SQLPS\Microsoft.SqlServer.Management.PSSnapins.dll
    if(!(Test-Path $snapin -PathType Leaf)) {return $false}
    Get-ChildItem $snapin |% {Test-WrongSnapin $_.FullName}
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

function Uninstall-OldModule
{
    # Win32_Product slowly reconfigures each entry, Win32Reg_AddRemovePrograms is faster
    # see https://sdmsoftware.com/group-policy-blog/wmi/why-win32_product-is-bad-news/
    # see also http://support.microsoft.com/kb/974524
    Get-WmiObject Win32Reg_AddRemovePrograms -Filter "DisplayName like 'Windows PowerShell Extensions for SQL Server %'" |
        ? {$Version -gt [version]$_.Version} |
        ? {$PSCmdlet.ShouldProcess($_.DisplayName,'Uninstall')} |
        % {Start-Process -FilePath msiexec.exe -ArgumentList '/x',$_.ProdID,'/passive','/norestart' -Wait -NoNewWindow}
}

function Remove-AnyOldModule
{
    if(!(Get-Module SQLPS -ListAvailable |? {Test-OldModule $_}))
    { Write-Host 'Found no old SQLPS modules.' -ForegroundColor Green -BackgroundColor DarkMagenta }
    else
    {
        Write-Verbose 'Found old SQLPS modules.'
        Get-Command msiexec.exe -CommandType Application -ErrorAction Stop |Out-Null
        Remove-Module SQLPS -ErrorAction SilentlyContinue
        Uninstall-OldModule
        Update-PSModulePath User
        Update-PSModulePath Machine
        Update-PSModulePathProcess
    }
}

function Download-Installer([string]$msi)
{
    $msiurl = New-Object uri $Source,$msi
    $sibling = Join-Path $PSScriptRoot $msi
    if(Test-Path $msi -PathType Leaf) {}
    elseif(($PSScriptRoot -ne $env:Temp) -and (Test-Path $sibling -PathType Leaf)) {Copy-Item $sibling}
    elseif(($Source.Scheme -eq 'file') -and (Test-Path $msiurl.LocalPath)) {Copy-Item $msiurl.LocalPath}
    else {Invoke-WebRequest $msiurl.AbsoluteUri -OutFile $msi}
}

function Install-NewModule
{
    if(Get-Module SqlServer -ListAvailable -Refresh)
    {
        Write-Host "You already have the latest SqlServer module." -ForegroundColor Green -BackgroundColor DarkMagenta
        return
    }
    Push-Location $env:Temp
    foreach($msi in @('SQLSysClrTypes.msi','SharedManagementObjects.msi','PowerShellTools.msi'))
    {
        if(!($PSCmdlet.ShouldProcess($msi,'Install'))) {continue}
        Download-Installer $msi
        Start-Process -FilePath msiexec.exe -ArgumentList '/i',$msi,'/passive','/norestart','INSTALLLEVEL=32767' -Wait -NoNewWindow
        Remove-Item $msi
    }
    Pop-Location
    Import-Module SqlServer
}

Remove-AnyOldModule
Install-NewModule
