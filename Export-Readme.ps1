<#
.Synopsis
	Generate README.md file for the scripts repo.

.Link
	https://www.microsoft.com/download/details.aspx?id=40760
#>

#Requires -Version 3
#Requires -Modules SqlServer
[CmdletBinding()][OutputType([void])] Param(
[string]$DependenciesImage = 'dependencies.svg',
[string]$StatusAge = '2 weeks ago'
)

function Format-Dependencies
{
	Write-Progress 'Building dependency graph'
	@'
digraph ScriptDependencies
{
	rankdir=RL
	node [shape=note style=filled fontname="Lucida Console" fontcolor=azure fillcolor=mediumblue color=azure]
	edge [color=goldenrod]
'@
	$path = $env:Path
	$env:Path = $PSScriptRoot
	[pscustomobject[]] $scripthelp = Get-Help *.ps1
	$i,$max = 0,($scripthelp.Count/100)
	foreach($help in $scripthelp)
	{
		Write-Progress 'Building dependency graph' 'Parsing dependencies' -curr $help.Name -percent ($i++/$max)
		Write-Verbose $help.Name
		if($help.Name -notlike "$PSScriptRoot\*" -or
			!(Get-Member relatedLinks -InputObject $help -MemberType Properties)) {continue}
		$help.relatedLinks.navigationLink |
			? {Get-Member linkText -InputObject $_ -MemberType Properties} |
			foreach {$_.linkText} |
			? {$_ -like '*.ps1'} |
			foreach {"    `"$(Split-Path $help.Name -Leaf)`" -> `"$_`" "}
	}
	$env:Path = $path
	@'
}
'@
	Write-Progress 'Building dependency graph' -Completed
}

function Export-Dependencies($image)
{
	Use-Command.ps1 dot "$env:ChocolateyInstall\bin\dot.exe" -cinst graphviz
	Write-Progress 'Creating dependency image'
	$gv = Join-Path $PSScriptRoot ([IO.Path]::ChangeExtension($image,'gv'))
	Format-Dependencies |Out-File $gv -Encoding ascii -Width ([int]::MaxValue)
	$ext = [IO.Path]::GetExtension($image).Trim('.')
	dot "-T$ext" -o $PSScriptRoot\$image $gv
	Remove-Item $gv
	Write-Progress 'Creating dependency image' -Completed
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
	Write-Progress 'Enumerating PowerShell scripts' 'Getting list of recent changes'
	$status = @{}
	git diff --name-status $(git rev-list -1 --before="$StatusAge" master) |
		foreach {if($_ -match '^(?<Status>\w)\t(?<Script>\S.*)') {$status[$Matches.Script] = Get-StatusSymbol $Matches.Status}}
	[IO.FileInfo[]] $scripts = Get-Item $PSScriptRoot\*.ps1
	$i,$max = 0,($scripts.Count/100)
	$scripts |
		foreach {Get-Help $_.FullName} |
		foreach {
			$name = Split-Path $_.Name -Leaf
			Write-Progress 'Enumerating PowerShell scripts' 'Writing list' -curr $name -percent ($i++/$max)
			$symbol = if($status.ContainsKey($name)){$status[$name]}
			"- $symbol**[$name]($name)**: $($_.Synopsis)"
		}
	Write-Progress 'Enumerating PowerShell scripts' -Completed
}

function Export-FSharpFormatting
{
	Write-Progress 'Exporting F# script documentation' 'Checking for FSharp.Formatting'
	Use-Command.ps1 dotnet "$env:ProgramFiles\dotnet\dotnet.exe" -cinst dotnet-sdk
	if("$(dotnet fsdocs version 2>&1)" -notmatch 'fsdocs *')
	{
		if(!(Test-Path .config/dotnet-tools.json -Type Leaf)) {dotnet new tool-manifest}
		dotnet tool install FSharp.Formatting.CommandTool
	}
	Write-Progress 'Exporting F# script documentation' 'Exporting literate documentation as HTML'
	$input,$output = "$PSScriptRoot\.fsxtmp","$PSScriptRoot\docs"
	if(Test-Path $input -PathType Container) {rm -Force -Recurse $input}
	mkdir $input |Out-Null
	Copy-Item $PSScriptRoot\*.fsx $input
	if(!(Test-Path $output -Type Container)) {mkdir $output}
	dotnet fsdocs build --input $input --output $output --noapidocs --parameters root / fsdocs-list-of-namespaces . 2>&1 |Write-Verbose
	Remove-Item -Force -Recurse $input
	Write-Progress 'Exporting F# script documentation' -Completed
}

function Format-FSScripts
{
	Export-FSharpFormatting
	Write-Progress 'Enumerating F# scripts'
	$base = 'https://webcoder.info/scripts/'
	$FSFHeadPattern = @'
(?mx) \A \s*
^\(\*\* \s* $ \s*
^(?<Title>\S.*\S) \s* $ \s*
^ =+ \r? $ \s*
^(?<Synopsis>\S.*\S) \s* $
'@
	[IO.FileInfo[]] $scripts = Get-Item $PSScriptRoot\*.fsx
	$i,$max = 0,($scripts.Count/100)
	$scripts |
		foreach {(Resolve-Path $_.FullName -Relative) -replace '\\','/' -replace '\A\./',''} |
		? {(Get-Content $_ -TotalCount 1) -match '\A\s*\(\*\*\s*\z'} |
		foreach {
			Write-Progress 'Enumerating F# scripts' 'Writing list' -curr $_ -percent ($i++/$max)
			if((Get-Content $_ -Raw) -match $FSFHeadPattern)
			{
				"- **[$($Matches.Title)]($base$([IO.Path]::ChangeExtension($_,'html')))**: $($Matches.Synopsis)"
			}
		}
	Write-Progress 'Enumerating F# scripts' -Completed
}

function Format-VBAScripts
{
	Write-Progress 'Enumerating VisualBasic for Applications scripts'
	$VBAHeadPattern = '(?mx) \A (?<Description>(?:^'' .* $ \s*)+) ^(?!'')'
	[IO.FileInfo[]] $scripts = Get-Item $PSScriptRoot\*.vba
	$i,$max = 0,($scripts.Count/100)
	$scripts |
		foreach {(Resolve-Path $_.FullName -Relative) -replace '\\','/' -replace '\A\./',''} |
		foreach {
			Write-Progress 'Enumerating VisualBasic for Applications scripts' 'Writing list' -curr $_ -percent ($i++/$max)
			if((Get-Content $_ -Raw) -match $VBAHeadPattern)
			{
				"- **[$_]($_)**: $($Matches.Description -replace '(?m)^''\s*','' -replace '\s+',' ')"
			}
		}
	Write-Progress 'Enumerating VisualBasic for Applications scripts' -Completed
}

function Format-SysCfgScripts
{
	Write-Progress 'Enumerating System Configuration PowerShell scripts'
	[IO.FileInfo[]] $scripts = Get-Item $PSScriptRoot\syscfg\*.ps1
	$i,$max = 0,($scripts.Count/100)
	$scripts |
		foreach {Get-Help $_.FullName} |
		foreach {
			Write-Progress 'Enumerating System Configuration PowerShell scripts' 'Writing list' -curr $_.Name -percent ($i++/$max)
			$name = Split-Path $_.Name -Leaf
			"- **[$name]($name)**: $($_.Synopsis)"
		}
	Write-Progress 'Enumerating System Configuration PowerShell scripts' -Completed
}

function Format-PS5Scripts
{
	Use-Command.ps1 powershell "$env:SystemRoot\system32\windowspowershell\v1.0\powershell.exe" -Message 'Missing PowerShell 5!'
	powershell -nol -nop -noni -Command @"
	& {
		Write-Progress 'Enumerating Windows PowerShell 5.x scripts'
		Import-Module Microsoft.PowerShell.Utility
		Add-Type -AN System.Web
		[IO.FileInfo[]] `$scripts = Get-Item $PSScriptRoot\PS5\*.ps1
		`$i,`$max = 0,(`$scripts.Count/100)
		`$scripts |
			foreach {Get-Help `$_.FullName} |
			foreach {
				Write-Progress 'Enumerating Windows PowerShell 5.x scripts' 'Writing list' -curr `$_.Name -percent (`$i++/`$max)
				'- **[{0}]({0})**: {1}' -f (Split-Path `$_.Name -Leaf),`$_.Synopsis
			}
		Write-Progress 'Enumerating Windows PowerShell 5.x scripts' -Completed
	}
"@
}

function Format-SysCfgReadme
{
	$local:OFS="`n"
	@"
PowerShell System Configuration Scripts
=======================================

A collection of scripts that only need to be run once to modify a system.

$(Format-SysCfgScripts)

<!-- generated $(Get-Date) -->
"@
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
	Write-Progress 'Building readme' 'Exporting dependencies'
	Export-Dependencies $DependenciesImage
	Write-Progress 'Building readme' 'Writing readme.md'
	$local:OFS="`n"
	@"
Useful General-Purpose Scripts
==============================

This repo contains a collection of generally useful scripts (mostly Windows PowerShell).

See [PS5](PS5) for legacy scripts, [syscfg](syscfg) for single-use system config scripts.

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
"@
	Write-Progress 'Building readme' -Completed
}

function Export-PSScriptPages
{
	Import-Module platyPS
	Write-Progress 'Export PowerShell script help pages' 'Removing docs for old scripts'
	Get-Item $PSScriptRoot\docs\*.ps1.md |
		where {!(Test-Path "$PSScriptRoot\$([IO.Path]::GetFileNameWithoutExtension($_.Name))" -Type Leaf)} |
		Remove-Item
	Write-Progress 'Export PowerShell script help pages' 'Updating script docs'
	Update-MarkdownHelp $PSScriptRoot\docs\*.ps1.md |Write-Verbose
	Write-Progress 'Export PowerShell script help pages' 'Adding docs for new scripts'
	Get-Item $PSScriptRoot\*.ps1 |
		where {!(Test-Path "$PSScriptRoot\$($_.Name).md" -Type Leaf)} |
		foreach {New-MarkdownHelp -Command $_.Name -OutputFolder docs} |
		Write-Verbose
	Write-Progress 'Export PowerShell script help pages' -Completed
}

Add-Type -AN System.Web
Format-Readme |Out-File $PSScriptRoot\README.md -Encoding utf8 -Width ([int]::MaxValue)
Format-SysCfgReadme |Out-File $PSScriptRoot\syscfg\README.md -Encoding utf8 -Width ([int]::MaxValue)
Format-PS5Readme |Out-File $PSScriptRoot\PS5\README.md -Encoding utf8 -Width ([int]::MaxValue)
Export-PSScriptPages
