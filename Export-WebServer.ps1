<#
.Synopsis
    Exports web server settings, shares, and installed MSAs.
#>

#Requires -RunAsAdministrator
[CmdletBinding()] Param()

Export-WebConfiguration.ps1 |Out-File "Import-${env:ComputerName}WebConfiguration.ps1" utf8
Export-SmbShares.ps1 |Out-File "Import-${env:ComputerName}SmbShares.ps1" utf8

function Export-Hosts
{
    if(!(Get-Content $env:SystemRoot\system32\drivers\etc\hosts |Select-String '^\s*\d')){return}
    Copy-Item $env:SystemRoot\system32\drivers\etc\hosts $PSScriptRoot
    @'
Move-Item $env:SystemRoot\system32\drivers\etc\hosts $env:SystemRoot\system32\drivers\etc\hosts.$(Get-Date -f yyyyMMddHHmmss)
Copy-Item $PSScriptRoot\hosts $env:SystemRoot\system32\drivers\etc\hosts
'@
}

@"
<#
.Synopsis
    Imports web server settings, shares, and installed MSAs exported from ${env:ComputerName}.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
#Requires -Module ActiveDirectory
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')] Param()

Write-Verbose 'Importing web configuration.'
`$PSScriptRoot\Import-${env:ComputerName}WebConfiguration.ps1

Write-Verbose 'Importing SMB shares.'
`$PSScriptRoot\Import-${env:ComputerName}SmbShares.ps1

if(`$PSCmdlet.ShouldProcess('MSAs','rebind'))
{
    Write-Verbose 'Rebinding managed service accounts.'
    Get-ADServiceAccount -Filter * |
        ? HostComputers -contains "`$(Get-ADComputer '${env:ComputerName}' |% DistinguishedName)" |
        Install-ADServiceAccount
}

$(Export-Hosts)
"@ |Out-File "Import-${env:ComputerName}.ps1" utf8
