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
    ls $PSScriptRoot\*.ps1 |
        % {Get-Help $_.FullName} |
        % {
            $name = Split-Path $_.Name -Leaf
            "- **[$name](blob/master/$name)**: $($_.Synopsis)"
        }
}

function Format-Dependencies
{
    if($PSScriptRoot -notin ($env:Path -split ';')) {$env:Path += ";$PSScriptRoot"}
    @'
digraph ScriptDependencies
{
    rankdir=RL
    node [shape=note style=filled fontname="Lucida Console" fontcolor=azure fillcolor=mediumblue color=azure]
    edge [color=goldenrod]
'@
    foreach($help in Get-Help *.ps1)
    {
        if($help.Name -notlike "$PSScriptRoot\*" -or !$help.relatedLinks) {continue}
        $help.relatedLinks.navigationLink.linkText |
            ? {$_ -like '*.ps1'} |
            % {"    `"$(Split-Path $help.Name -Leaf)`" -> `"$_`" "}
    }
    @'
}
'@
}

function Format-Readme
{$local:OFS="`n";@"
Useful General-Purpose Scripts
==============================
This repo contains a collection of generally useful scripts (mostly Windows, mostly PowerShell).

PowerShell Scripts
------------------

![script dependencies](dependencies.png)

$(Format-PSScripts)

<!-- generated $(Get-Date) -->
"@}

Use-Command.ps1 dot ${env:ProgramFiles(x86)}\Graphviz*\bin\dot.exe -msi http://graphviz.org/pub/graphviz/stable/windows/graphviz-2.38.msi
Format-Dependencies |Out-File $PSScriptRoot\dependencies.gv -Encoding ascii
dot -Tpng -o $PSScriptRoot\dependencies.png $PSScriptRoot\dependencies.gv
rm dependencies.gv
Format-Readme |Out-File $PSScriptRoot\README.md
