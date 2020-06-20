<#
.Synopsis
    Generate README.md file for the scripts repo.

.Link
    https://www.microsoft.com/download/details.aspx?id=40760
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding()][OutputType([void])] Param(
[string]$DependenciesImage = 'dependencies.svg',
[string]$StatusAge = '2 weeks ago'
)

function Format-Dependencies
{
    @'
digraph ScriptDependencies
{
    rankdir=RL
    node [shape=note style=filled fontname="Lucida Console" fontcolor=azure fillcolor=mediumblue color=azure]
    edge [color=goldenrod]
'@
    $path = $env:Path
    $env:Path = $PSScriptRoot
    foreach($help in Get-Help *.ps1)
    {
        Write-Verbose $help.Name
        if($help.Name -notlike "$PSScriptRoot\*" -or
            !(Get-Member relatedLinks -InputObject $help -MemberType Properties)) {continue}
        $help.relatedLinks.navigationLink |
            ? {Get-Member linkText -InputObject $_ -MemberType Properties} |
            % {$_.linkText} |
            ? {$_ -like '*.ps1'} |
            % {"    `"$(Split-Path $help.Name -Leaf)`" -> `"$_`" "}
    }
    $env:Path = $path
    @'
}
'@
}

function Export-Dependencies($image)
{
    Use-Command.ps1 dot ${env:ProgramFiles(x86)}\Graphviz*\bin\dot.exe -msi http://graphviz.org/pub/graphviz/stable/windows/graphviz-2.38.msi
    $gv = Join-Path $PSScriptRoot ([IO.Path]::ChangeExtension($image,'gv'))
    Format-Dependencies |Out-File $gv -Encoding ascii -Width ([int]::MaxValue)
    $ext = [IO.Path]::GetExtension($image).Trim('.')
    dot "-T$ext" -o $PSScriptRoot\$image $gv
    rm $gv
}

function Get-StatusSymbol([string]$status)
{
    switch($status)
    {
        A {':new: '}
        B {':heavy_exclamation_mark: '}
        C {':heavy_plus_sign: '}
        D {':heavy_minus_sign: '}
        M {':up: '}
        R {':name_badge: '}
        T {':wavy_dash: '}
        U {':red_circle: '}
        X {':large_orange_diamond: '}
        default {':large_blue_diamond: '}
    }
}

function Format-PSScripts
{
    $status = @{}
    git diff --name-status $(git rev-list -1 --before="$StatusAge" master) |
        % {if($_ -match '^(?<Status>\w)\t(?<Script>\S.*)') {$status[$Matches.Script] = Get-StatusSymbol $Matches.Status}}
    ls $PSScriptRoot\*.ps1 |
        % {Get-Help $_.FullName} |
        % {
            $name = Split-Path $_.Name -Leaf
            $symbol = if($status.ContainsKey($name)){$status[$name]}
            "- $symbol**[$name]($name)**: $($_.Synopsis)"
        }
}

function Install-RequiredPackages
{
    Use-Command.ps1 paket $PSScriptRoot -url (irm http://fsprojects.github.io/Paket/stable)
    if(Test-Path paket.lock -PathType Leaf) {paket restore}
    else {paket install |Write-Host}
}

function Export-FSharpFormatting
{
    $tmp = "$PSScriptRoot\fsxtmp"
    if(Test-Path $tmp -PathType Container) {rm -Force -Recurse $tmp}
    mkdir $tmp |Out-Null
    cp $PSScriptRoot\*.fsx $tmp
    ${fsformatting.exe} = "$PSScriptRoot\packages\FSharp.Formatting.CommandTool\tools\fsformatting.exe"
    if(!(Test-Path ${fsformatting.exe} -PathType Leaf)) {Install-RequiredPackages}
    $fmtargs = @(
        'literate','--processDirectory','--inputDirectory',"$PSScriptRoot\fsxtmp",'--templateFile',
        "$PSScriptRoot\fsxfmt\template.html"
    )
    Write-Verbose "${fsformatting.exe} $fmtargs"
    & ${fsformatting.exe} @fmtargs |Write-Verbose
    cp $tmp\*.html $PSScriptRoot
    rm -Force -Recurse $tmp
}

function Format-FSScripts
{
    Export-FSharpFormatting
    $base = 'https://cdn.rawgit.com/brianary/scripts/master/'
    $FSFHeadPattern = @'
(?mx) \A \s*
^\(\*\* \s* $ \s*
^(?<Title>\S.*\S) \s* $ \s*
^ =+ \r? $ \s*
^(?<Synopsis>\S.*\S) \s* $
'@
    ls $PSScriptRoot\*.fsx |
        % {(Resolve-Path $_.FullName -Relative) -replace '\\','/' -replace '\A\./',''} |
        ? {(Get-Content $_ -TotalCount 1) -match '\A\s*\(\*\*\s*\z'} |
        % {
            if((Get-Content $_ -Raw) -match $FSFHeadPattern)
            {
                "- **[$($Matches.Title)]($base$([IO.Path]::ChangeExtension($_,'html')))**: $($Matches.Synopsis)"
            }
        }
}

function Format-VBAScripts
{
    $VBAHeadPattern = '(?mx) \A (?<Description>(?:^'' .* $ \s*)+) ^(?!'')'
    ls $PSScriptRoot\*.vba |
        % {(Resolve-Path $_.FullName -Relative) -replace '\\','/' -replace '\A\./',''} |
        % {
            if((Get-Content $_ -Raw) -match $VBAHeadPattern)
            {
                "- **[$_]($_)**: $($Matches.Description -replace '(?m)^''\s*','' -replace '\s+',' ')"
            }
        }
}

function Format-PS5Scripts
{
    ls $PSScriptRoot\PS5\*.ps1 |
        % {Get-Help $_.FullName} |
        % {
            $name = Split-Path $_.Name -Leaf
            "- **[$name]($name)**: $($_.Synopsis)"
        }
}

function Format-PS5Readme
{
	$local:OFS="`n"
	@"
PowerShell 5.1 Scripts
======================

A collection of legacy scripts that have been supplanted by newer scripts or modules for PowerShell 6+,
or have dependencies that are no longer available in PowerShell 6+.

$(Format-PS5Scripts)

<!-- generated $(Get-Date) -->
"@
}

function Format-Readme
{
    Export-Dependencies $DependenciesImage
    $local:OFS="`n"
    @"
Useful General-Purpose Scripts
==============================

This repo contains a collection of generally useful scripts (mostly Windows PowerShell).

PowerShell Scripts
------------------
![script dependencies]($DependenciesImage)

$(Format-PSScripts)

F# Scripts
----------
$(Format-FSScripts)

Office VBA Scripts
------------------
$(Format-VBAScripts)

<!-- generated $(Get-Date) -->
"@}

Format-Readme |Out-File $PSScriptRoot\README.md -Encoding utf8 -Width ([int]::MaxValue)
Format-PS5Readme |Out-File $PSScriptRoot\PS5\README.md -Encoding utf8 -Width ([int]::MaxValue)
