<#
.Synopsis
Checks for the existence of the given command, and adds if missing and a source is defined.
.Description
Use-Command checks to see if a command exists by the name given.

If the command does not exist, but the path is valid, an alias is created.

Otherwise, if one of several installation methods is provided, an installation attempt is made before aliasing.
.Parameter Name
The name of the command to test.
.Parameter Path
The full path of the command, if installed.
Accepts wildcards, as supported by Resolve-Path.
.Parameter NugetPackage
The name of the NuGet package to install if the command is missing.
.Parameter NodePackage
The name of the Node NPM package to install if the command is missing.
.Parameter InstallDir
The directory to install NuGet or Node packages to.
Node will create and use a "node_modules" folder under this one.
Default is C:\Tools
.Parameter WindowsInstaller
The location (file or URL) of an MSI package to install if the command is missing.
.Parameter InstallLevel
The INSTALLLEVEL to pass to Windows Installer.
Default is 32767
.Parameter ExecutableInstaller
The location (file or URL) of an .exe installer to use if the command is missing.
.Parameter InstallerParameters
Parameters to pass to the .exe installer.
.Parameter ExecutePS
The URL or file path of a PowerShell script to download and execute to install the command if it is missing.
.Parameter DownloadZip
The URL to download a .zip file containing the command if it is missing.
.Parameter DownloadUrl
The URL to download the command from if it is missing.
.Parameter Message
A message to display, rather than attempting to install a missing command.
.Parameter Fail
Throw an exception rather than attempt to install a missing command.
.Link
Resolve-Path
.Link
SupportsShouldProcess Usage: http://www.iheartpowershell.com/2013/05/powershell-supportsshouldprocess-worst.html
.Example
Use-Command.ps1 nuget $ToolsDir\NuGet\nuget.exe -url http://www.nuget.org/nuget.exe
This example downloads and aliases nuget, if missing.
.Example
Use-Command.ps1 npm 'C:\Program Files\nodejs\npm.cmd' -msi http://nodejs.org/dist/v0.10.33/x64/node-v0.10.33-x64.msi
This example downloads and silently installs node if npm is missing.
#>

#requires -Version 2
#requires -Modules Microsoft.PowerShell.Utility
[CmdletBinding(SupportsShouldProcess=$true)]
Param([Parameter(Position=0,Mandatory=$true)]$Name, 
[Parameter(Position=1,Mandatory=$true)][string]$Path,
[Parameter(ParameterSetName='NugetPackage')][Alias('nupkg')][string]$NugetPackage,
[Parameter(ParameterSetName='NodePackage')][Alias('npm')][string]$NodePackage,
[Parameter(ParameterSetName='NugetPackage')]
[Parameter(ParameterSetName='NodePackage')]
[Alias('dir')][string]$InstallDir = 'C:\Tools',
[Parameter(ParameterSetName='WindowsInstaller')]
[Alias('msi')][uri]$WindowsInstaller,
[Parameter(ParameterSetName='WindowsInstaller')]
[int]$InstallLevel = 32767,
[Parameter(ParameterSetName='ExecutableInstaller')]
[Alias('exe')][string]$ExecutableInstaller,
[Parameter(ParameterSetName='ExecutableInstaller')]
[Alias('params')][string[]]$InstallerParameters = @(),
[Parameter(ParameterSetName='ExecutePS')][Alias('iex')][uri]$ExecutePS,
[Parameter(ParameterSetName='DownloadZip')][Alias('zip')][uri]$DownloadZip,
[Parameter(ParameterSetName='DownloadUrl')][Alias('url')][uri]$DownloadUrl,
[Parameter(ParameterSetName='WarnOnly')]
[Alias('msg')][string]$Message,
[Parameter(ParameterSetName='Fail')]
[switch]$Fail
)
function Set-ResolvedAlias([Parameter(Position=0)][string]$Name,[Parameter(Position=1)][string]$Path)
{ Set-Alias $Name (Resolve-Path $Path |select -Last 1 -ExpandProperty Path) -Scope Global }
Get-Command $Name -EA SilentlyContinue -EV cmerr |Out-Null
if(!$cmerr) { Write-Verbose "$Name command found." ; return }
if($Path -and (Test-Path $Path)) { Set-ResolvedAlias $Name $Path ; return }
if($NugetPackage)
{
    if($PSCmdlet.ShouldProcess("This will use NuGet to install $NugetPackage to $InstallDir.",
        "Are you sure you wish to install $Name ?",
        "NuGet Install $NugetPackage"))
    {
        nuget install $NugetPackage -x -o $InstallDir -NonInteractive
        Set-ResolvedAlias $Name $Path
    }
    else { Write-Error "Installation of $NugetPackage was cancelled." }
}
elseif($NodePackage)
{
    if(!(Test-Path "$env:USERPROFILE\AppData\Roaming\npm" -PathType Container)) 
    { mkdir "$env:USERPROFILE\AppData\Roaming\npm" |Out-Null }
    if($PSCmdlet.ShouldProcess("This will use Node NPM to install $NodePackage to $InstallDir.",
        "Are you sure you wish to install $Name ?",
        "Node Install $NodePackage"))
    {
        pushd $InstallDir
        npm install $NodePackage
        popd
        Set-ResolvedAlias $Name $Path
    }
    else { Write-Error "Installation of $NodePackage was cancelled." }
}
elseif($WindowsInstaller)
{
    $file = $WindowsInstaller.Segments[$WindowsInstaller.Segments.Length-1]
    if($PSCmdlet.ShouldProcess("This will use Windows Installer to install $file hands-free with INSTALLLEVEL set to $InstallLevel.",
        "Are you sure you wish to install $file ?",
        "Windows Install $file"))
    {
        $msi =
            if($WindowsInstaller.IsUnc)
            { Copy-Item $WindowsInstaller $env:TEMP; "$env:TEMP\$file" }
            elseif($WindowsInstaller.IsFile)
            { [string]$WindowsInstaller }
            else
            { (New-Object System.Net.WebClient).DownloadFile($WindowsInstaller,"$env:TEMP\$file"); "$env:TEMP\$file" }
        msiexec /i $msi /passive /qb INSTALLLEVEL=$InstallLevel
        while(!(Test-Path $Path) -and $PSCmdlet.ShouldContinue(
            "The file $Path was still not found. Continue waiting for installation?","Await Installation")) { Start-Sleep 5 }
        if(Test-Path $Path) { Set-ResolvedAlias $Name $Path }
    }
    else { Write-Error "Installation of $WindowsInstaller was cancelled." }
}
elseif($ExecutableInstaller)
{
    $file = $ExecutableInstaller.Segments[$WindowsInstaller.Segments.Length-1]
    if($PSCmdlet.ShouldProcess("This will install $file $InstallerParameters.",
        "Are you sure you wish to install $file ?",
        "Install $file"))
    {
        $exe =
            if($ExecutableInstaller.IsUnc)
            { Copy-Item $ExecutableInstaller $env:TEMP; "$env:TEMP\$file" }
            elseif($ExecutableInstaller.IsFile)
            { [string]$ExecutableInstaller }
            else
            { (New-Object System.Net.WebClient).DownloadFile($ExecutableInstaller,"$env:TEMP\$file"); "$env:TEMP\$file" }
        & $exe @InstallerParameters
        while(!(Test-Path $Path) -and $PSCmdlet.ShouldContinue(
            "The file $Path was still not found. Continue waiting for installation?","Await Installation")) { Start-Sleep 5 }
        if(Test-Path $Path) { Set-ResolvedAlias $Name $Path }
    }
    else { Write-Error "Installation of $WindowsInstaller was cancelled." }
}
elseif($ExecutePS)
{
    if($PSCmdlet.ShouldProcess("This will execute $ExecutePS.",
        "Are you sure you wish to execute $ExecutePS ?",
        "Execute PowerShell Script"))
    {
        switch($ExecutePS.Scheme)
        {
            file    { Invoke-Expression (gc $ExecutePS.OriginalString -raw) }
            default { Invoke-Expression ((new-object net.webclient).DownloadString($ExecutePS)) }
        }
    }
    else { Write-Error "Execution of $ExecutePS was cancelled." }
}
elseif($DownloadZip)
{
    if($PSCmdlet.ShouldProcess("This will download and unzip $DownloadZip to $Path.",
        "Are you sure you wish to download $Name ?",
        "Download $Name"))
    {
        $dir = Split-Path $Path
        $filename = [IO.Path]::GetFileName($DownloadZip.LocalPath)
        if (!(Test-Path $dir -PathType Container)) { mkdir $dir |Out-Null }
        $zippath = Join-Path $env:TEMP $filename
        Write-Verbose "Downloading $DownloadZip to $path"
        (New-Object System.Net.WebClient).DownloadFile($DownloadZip,$zippath)
        Add-Type -AN System.IO.Compression.FileSystem
        Write-Verbose "Copying zipped items from $zippath to $dir"
        [IO.Compression.ZipFile]::ExtractToDirectory($zippath,$dir)
        Set-ResolvedAlias $Name $Path
    }
    else { Write-Error "Download/unzip of $Name was cancelled." }
}
elseif($DownloadUrl)
{
    if($PSCmdlet.ShouldProcess("This will download $DownloadUrl to $Path.",
        "Are you sure you wish to download $Name ?",
        "Download $Name"))
    {
        $dir = Split-Path $Path
        if (!(Test-Path $dir -PathType Container)) { mkdir $dir |Out-Null }
        (New-Object System.Net.WebClient).DownloadFile($DownloadUrl,$Path)
        Set-ResolvedAlias $Name $Path
    }
    else { Write-Error "Download of $Name was cancelled." }
}
elseif($Message)
{
    Write-Warning $Message
}
else
{
    throw "$Name command not found!"
}
