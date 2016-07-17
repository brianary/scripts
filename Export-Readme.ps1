<#
.Synopsis
    Generate README.md file for the scripts repo.

.Link
    https://www.microsoft.com/download/details.aspx?id=40760
#>

#requires -Version 3
[CmdletBinding()] Param(
)

function Format-PSScripts
{
    ls $PSScriptRoot\*.ps1 |% {Get-Help $_.FullName} |% {"- **$(Split-Path $_.Name -Leaf)**: $($_.Synopsis)"}
}

function Format-Readme
{$local:OFS="`n";@"
Useful General-Purpose Scripts
==============================
This repo contains a collection of generally useful scripts (mostly Windows, mostly PowerShell).

PowerShell Scripts
------------------
$(Format-PSScripts)

<!-- generated $(Get-Date) -->
"@}

Format-Readme |Out-File $PSScriptRoot\README.md utf8
