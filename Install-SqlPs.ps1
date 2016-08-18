<#
.Synopsis
    Installs SQLPS module and dependencies.

.Parameter Version
    The version number to install.
    Used to determine which installed versions are too old.

.Parameter Source
    A file directory or base URI to download the required MSI files from.

.Link
    Start-Process

.Link
    Invoke-WebRequest

.Link
    Import-Module

.Link
    https://www.microsoft.com/download/details.aspx?id=52676

.Example
    Install-SqlPs.ps1


    Removes old versions of SQLPS, and installs the latest, as needed.

.Example
    Install-SqlPs.ps1 -Source $env:USERPROFILE\Downloads


    Uses already downloaded versions of the installers.
#>

#requires -version 3
#requires -RunAsAdministrator
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)]Param(
[version]$Version = '13.0.1601.5',
[uri]$Source = 'https://download.microsoft.com/download/8/7/2/872BCECA-C849-4B40-8EBE-21D48CDF1456/ENU/x64/'
)

function Test-OldSnapin([IO.FileInfo]$Path)
{
    $old = 
        if($Version -gt [version]$Path.VersionInfo.ProductVersion) {$true}
        elseif(!([Environment]::Is64BitProcess)) {$true}
        else {$Path.FullName.StartsWith((Join-Path ${env:ProgramFiles(x86)} ''))}
    Write-Verbose "'$Path' old? $old"
    $old
}

function Test-OldSqlPs([Management.Automation.PSModuleInfo]$module)
{
    Join-Path $module.Path ..\Microsoft.SqlServer.Management.PSSnapins.dll |
        Get-ChildItem |
        % {Test-OldSnapin $_.FullName}
}

function Test-OldSqlPsPath([string]$Path)
{
    $snapin = Join-Path $Path SQLPS\Microsoft.SqlServer.Management.PSSnapins.dll
    if(!(Test-Path $snapin -PathType Leaf)) {return $false}
    Get-ChildItem $snapin |% {Test-OldSnapin $_.FullName}
}

function Update-PSModulePath([EnvironmentVariableTarget]$Target)
{
    if(!$PSCmdlet.ShouldProcess("$Target PSModulePath",'Update')) {return}
    $modulepath = [Environment]::GetEnvironmentVariable('PSModulePath',$Target)
    Write-Verbose "Initial $Target PSModulePath: $modulepath"
    $modulepath = ($modulepath -split ';' |? {!(Test-OldSqlPsPath $_)}) -join ';'
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

function Uninstall-OldSqlPs
{
    Get-WmiObject Win32Reg_AddRemovePrograms -Filter "DisplayName like 'Windows PowerShell Extensions for SQL Server %'" |
        ? {$Version -gt [version]$_.Version} |
        ? {$PSCmdlet.ShouldProcess($_.DisplayName,'Uninstall')} |
        % {Start-Process -FilePath msiexec.exe -ArgumentList '/x',$_.ProdID,'/passive','/norestart' -Wait -NoNewWindow}
}

function Remove-AnyOldSqlPs
{
    if(!(Get-Module SQLPS -ListAvailable |? {Test-OldSqlPs $_}))
    { Write-Host 'Found no old SQLPS modules.' -ForegroundColor Green -BackgroundColor DarkMagenta }
    else
    {
        Write-Verbose 'Found old SQLPS modules.'
        Get-Command msiexec.exe -CommandType Application -ErrorAction Stop |Out-Null
        Remove-Module SQLPS -ErrorAction SilentlyContinue
        Uninstall-OldSqlPs
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

function Install-NewSqlPs
{
    if(Get-Module SQLPS -ListAvailable -Refresh |? {!(Test-OldSqlPs $_)})
    {
        Write-Host "You already have the latest SQLPS." -ForegroundColor Green -BackgroundColor DarkMagenta
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
    Import-Module SQLPS
}

Remove-AnyOldSqlPs
Install-NewSqlPs
