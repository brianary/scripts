<#
.Synopsis
    Installs the PowerShell ActiveDirectory module.
#>

[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param()
if(!$PSCmdlet.ShouldProcess('ActiveDirectory module','install')) {return}
DISM /online /enable-feature /featurename=RemoteServerAdministrationTools `
    /featurename=RemoteServerAdministrationTools-Roles `
    /featurename=RemoteServerAdministrationTools-Roles-AD `
    /featurename=RemoteServerAdministrationTools-Roles-AD-Powershell