<#
.Synopsis
    Durably installs the PowerShell ActiveDirectory module.

.Link
    Install-WindowsFeature

.Link
    https://docs.microsoft.com/windows-hardware/manufacture/desktop/dism-image-management-command-line-options-s14

.Link
    https://www.microsoft.com/en-us/download/details.aspx?id=45520

.Link
    https://bit.ly/Win10RSATinstall2

.Link
    https://chocolatey.org/
#>

[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)][OutputType([void])] Param()
if(!$PSCmdlet.ShouldProcess('ActiveDirectory module','install')) {return}
if([Environment]::OSVersion.Version -lt [version]'6.2')
{
    Write-Verbose "Installing RSAT+AD-PS pre-Win8 via DISM"
    # see DISM /online /get-features /format:table
    DISM /online /enable-feature /featurename=RemoteServerAdministrationTools `
        /featurename=RemoteServerAdministrationTools-Roles `
        /featurename=RemoteServerAdministrationTools-Roles-AD `
        /featurename=RemoteServerAdministrationTools-Roles-AD-Powershell
    return
}
if((Get-Command Install-WindowsFeature -CommandType Cmdlet -ErrorAction SilentlyContinue))
{
    Install-WindowsFeature RSAT,RSAT-Role-Tools,RSAT-AD-Tools,RSAT-AD-PowerShell
}
Use-Command.ps1 cinst "$env:ChocolateyInstall\bin\cinst.exe" -ExecutePowerShell https://chocolatey.org/install.ps1
if((Get-Command cinst -CommandType Application -ErrorAction SilentlyContinue))
{
    Write-Verbose "Installing RSAT via Chocolatey"
    cinst rsat -params '"/Server:2016"' -y
    return
}
if([Environment]::OSVersion.Version -gt [version]'9.0')
{
    Write-Verbose "Installing RSAT for Windows 10 by downloading .msu file"
    [uri]$msuUrl = "https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/WindowsTH-RSAT_WS2016-$($env:PROCESSOR_ARCHITECTURE -replace '\A\D+','x').msu"
    $msuFile = Join-Path $env:TEMP $msuUrl.Segments[-1]
    Invoke-WebRequest $msuUrl -UseBasicParsing -OutFile $msuFile
    Start-Process wusa $msuFile,'/quiet' -Wait -NoNewWindow
    return
}
throw 'Unable to install RSAT via DISM, ServerManager module, Chocolatey, or downloading the Windows Installer.'
