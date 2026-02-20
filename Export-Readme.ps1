<#
.SYNOPSIS
Generate README.md file for the scripts repo.

.LINK
https://www.microsoft.com/download/details.aspx?id=40760
#>

#Requires -Version 7
#Requires -Modules SqlServer
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','',
Justification='This script deals with lists, and this is a pretty questionable rule.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter','',
Justification='ScriptAnalyzer does not recognize parameters used as global values.')]
[CmdletBinding()][OutputType([void])] Param(
# The oldest change to mark as updated.
[string] $StatusAge = '2 weeks ago',
# Commit the update.
[switch] $Commit
)

function Get-StatusSymbol([string]$status,[switch]$entity)
{
	if($entity)
	{
		switch($status)
		{
			A {'&#x1F195; '}
			B {'&#x2757; '}
			C {'&#x2795; '}
			D {'&#x2796; '}
			M {'&#x1F199; '}
			R {'&#x1F4DB; '}
			T {'&#x3030;&#xFE0F; '}
			U {'&#x1F534; '}
			X {'&#x1F538; '}
			default {'&#x1F537; '}
		}
	}
	else
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
}

filter Test-HasTest([ValidateScript({Test-Path $_.FullName -Type Leaf})][IO.FileInfo] $Script)
{
	if($Script.Name -notmatch '\A\w+-\w+\.ps1\z') {return $false}
	if(Test-Path "$PSScriptRoot\test\$($Script.BaseName).Tests.ps1" -Type Leaf) {return $true}
	else {return $false}
}

function Measure-PesterCoveragePerMil([Parameter(ValueFromPipeline)][IO.FileInfo] $Script)
{
	End
	{
		return [int](1000 * ($input |Where-Object {Test-HasTest $_} |Measure-Object).Count / $input.Count)
	}
}

function Measure-CommitsTimeSpan
{
	[CmdletBinding()][OutputType([TimeSpan])] Param(
	[Parameter(Mandatory=$true)][string] $Path
	)
	return git log --follow --format=%ad --date=iso ($Path -replace '\\','/') |
		ForEach-Object {[DateTimeOffset]$_} |
		Measure-Object -Minimum -Maximum |
		ForEach-Object {$_.Maximum - $_.Minimum}
}

filter Format-RoundTimeSpan([Parameter(ValueFromPipeline)][TimeSpan] $TimeSpan)
{
	switch($TimeSpan)
	{
		{$_.Days -gt 0}         {return "$($_.Days) days"}
		{$_.Hours -gt 0}        {return "$($_.Hours) hours"}
		{$_.Minutes -gt 0}      {return "$($_.Minutes) minutes"}
		{$_.Seconds -gt 0}      {return "$($_.Seconds) seconds"}
		{$_.Milliseconds -gt 0} {return "$($_.Milliseconds) milliseconds"}
		{$_.Microseconds -gt 0} {return "$($_.Microseconds) microseconds"}
		{$_.Ticks -eq 0}        {return "at once"}
		default                 {return "$($_.Ticks) ticks"}
	}
}

function Get-PesterCoverageBadge([switch]$UseLines)
{
	if($UseLines)
	{
		$unit = [uri]::EscapeUriString((Get-Unicode.ps1 0x2031)) # PER TEN THOUSAND SIGN (permyriad)
		[int] $coverage = 10000 * (Get-Item $PSScriptRoot\*.ps1 |
			Where-Object {Test-HasTest $_} |
			Get-Content |
			Measure-Object -Line).Lines /
			(Get-Item $PSScriptRoot\*.ps1 |Get-Content |Measure-Object -Line).Lines
		$color = switch($coverage)
		{
			{$_ -gt 9500} {'brightgreen'}
			{$_ -gt 8000} {'green'}
			{$_ -gt 5000} {'yellowgreen'}
			{$_ -gt 3000} {'orange'}
			{$_ -gt  500} {'red'}
			default       {'lightgray'}
		}
	}
	else
	{
		$unit = [uri]::EscapeUriString((Get-Unicode.ps1 0x2030)) # PER MILLE SIGN (permil)
		[int] $coverage = 1000 * (Get-Item $PSScriptRoot\test\*.ps1 |Measure-Object).Count /
			(Get-Item $PSScriptRoot\*.ps1 |Measure-Object).Count
		$color = switch($coverage)
		{
			{$_ -gt 950} {'brightgreen'}
			{$_ -gt 800} {'green'}
			{$_ -gt 500} {'yellowgreen'}
			{$_ -gt 300} {'orange'}
			{$_ -gt  50} {'red'}
			default      {'lightgray'}
		}
	}
	return "https://img.shields.io/badge/Pester_coverage-${coverage}_$unit-$color"
}

function Format-PSScripts([string] $Extension = '', [switch] $entities)
{
	Write-Progress 'Enumerating PowerShell scripts' 'Getting list of recent changes'
	$status = @{}
	git diff --name-status $(git rev-list -1 --before="$StatusAge" main) |
		ForEach-Object {
			if($_ -match '^(?<Status>\w)\t(?<Script>\S.*)')
			{
				$status[$Matches.Script] = Get-StatusSymbol $Matches.Status -entity:$entities
			}
		}
	[Microsoft.PowerShell.Commands.GroupInfo[]] $functionalities = Get-Item $PSScriptRoot\*.ps1 |
		ForEach-Object {Get-Help $_.FullName} |
		Group-Object Functionality |
		Sort-Object {if($_.Name){$_.Name}else{'ZZZ'}}
	foreach($functionality in $functionalities)
	{
		''
		$category = if($functionality.Name) {$functionality.Name} else {'Other'}
		"### $category"
		''
		$functionality.Group |
			ForEach-Object {
				$name = Split-Path $_.Name -Leaf
				$symbol = if($status.ContainsKey($name)){$status[$name]}
				"- $symbol**[$name]($name$Extension)**: $($_.Synopsis)"
			}
	}
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
	if(Test-Path $input -PathType Container) {Remove-Item -Force -Recurse $input}
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
		ForEach-Object {(Resolve-Path $_.FullName -Relative) -replace '\\','/' -replace '\A\./',''} |
		Where-Object {(Get-Content $_ -TotalCount 1) -match '\A\s*\(\*\*\s*\z'} |
		ForEach-Object {
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
	[IO.FileInfo[]] $scripts = Get-Item .\*.vba
	$i,$max = 0,($scripts.Count/100)
	$scripts |
		ForEach-Object {(Resolve-Path $_.FullName -Relative) -replace '\\','/' -replace '\A\./',''} |
		ForEach-Object {
			Write-Progress 'Enumerating VisualBasic for Applications scripts' 'Writing list' -curr $_ -percent ($i++/$max)
			if((Get-Content $_ -Raw) -match $VBAHeadPattern)
			{
				"- **[$_]($_)**: $($Matches.Description -replace '(?m)^''\s*','' -replace '\s+',' ')"
			}
		}
	Write-Progress 'Enumerating VisualBasic for Applications scripts' -Completed
}

filter Format-TestsVerb
{
	Param(
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Name,
	[Parameter(ValueFromPipelineByPropertyName=$true)][IO.FileInfo[]] $Group
	)
	$permil = $Group |Measure-PesterCoveragePerMil
	$time = $permil -eq 0 ? '' : "&#x1F4C5; $(Measure-CommitsTimeSpan "$PSScriptRoot\test\$Name*.Tests.ps1" |Format-RoundTimeSpan)"
	$progress = $permil -eq 0 ? 'not started' : "<meter low='300' max='1000' optimum='1000' value='$permil'>$permil &#x2030;</meter>"
	$Local:OFS = [Environment]::NewLine
	return @"
<li><details><summary>$progress $Name ($($Group.Count)) $time</summary>

$($Group |ForEach-Object {"- $((Test-HasTest $_) ? '&#x2714;&#xFE0F;' : '&#x2716;&#xFE0F;') $($_.Name)"})

</details></li>
"@
}

filter Format-TestsLetter
{
	Param(
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Name,
	[Parameter(ValueFromPipelineByPropertyName=$true)][IO.FileInfo[]] $Group
	)
	$permil = $Group |Measure-PesterCoveragePerMil
	$time = $permil -eq 0 ? '' : "&#x1F4C5; $(Measure-CommitsTimeSpan "$PSScriptRoot\test\$Name*.Tests.ps1" |Format-RoundTimeSpan)"
	$progress = $permil -eq 0 ? 'not started' : "<meter low='300' max='1000' optimum='1000' value='$permil'>$permil &#x2030;</meter>"
	$Local:OFS = [Environment]::NewLine
	return @"
<li><details><summary>$progress $Name ($($Group.Count)) $time</summary>
<ul>$($Group |Group-Object {($_.BaseName -split '-',2)[0]} |Format-TestsVerb)</ul></details></li>
"@
}

function Format-TestsReadme
{
	$Scripts = Get-Item $PSScriptRoot\*.ps1
	$permil = $Scripts |Measure-PesterCoveragePerMil
	$time = $permil -eq 0 ? '' : "&#x1F4C5; $(Measure-CommitsTimeSpan "$PSScriptRoot\test\*.Tests.ps1" |Format-RoundTimeSpan)"
	$progress = $permil -eq 0 ? 'not started' : "<meter low='300' max='1000' optimum='1000' value='$permil'>$permil &#x2030;</meter>"
	$Local:OFS = [Environment]::NewLine
	return @"
Script Tests
============

<details><summary>$progress Scripts repo ($($Scripts.Count)) $time</summary>
<ul>$(Get-Item $PSScriptRoot\*.ps1 |Group-Object {$_.Name[0]} |Format-TestsLetter)</ul></details>
"@
}

function Format-Readme
{
	Write-Progress 'Building readme' 'Exporting dependencies'
	Write-Progress 'Building readme' 'Writing readme.md'
	$Local:OFS = [Environment]::NewLine
	return @"
Useful General-Purpose Scripts
==============================

[![Pester tests results](https://gist.githubusercontent.com/brianary/4642e5c804aa1b40738def5a7c03607a/raw/badge.svg)][pester.yml]
[![Pester tests coverage]($(Get-PesterCoverageBadge -UseLines))](https://github.com/brianary/scripts/tree/main/test)
[![GitHub license badge](https://badgen.net/github/license/brianary/Scripts?icon=github)](https://mit-license.org/ "MIT License")
[![GitHub stars badge](https://badgen.net/github/stars/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/stargazers "Stars")
[![GitHub watchers badge](https://badgen.net/github/watchers/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/watchers "Watchers")
[![GitHub forks badge](https://badgen.net/github/forks/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/network/members "Forks")
[![GitHub issues badge](https://badgen.net/github/open-issues/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/issues "Issues")
[![GitHub commits badge](https://badgen.net/github/commits/brianary/Scripts/main?icon=git)](https://github.com/brianary/scripts/commits/main "Commits")
[![GitHub last commit badge](https://badgen.net/github/last-commit/brianary/Scripts/main?icon=git)](https://github.com/brianary/scripts/commits/main "Last commit")
[![Mastodon: @dataelemental@mastodon.social](https://badgen.net/badge/@dataelemental/@mastodon.social/blue?icon=mastodon)](https://mastodon.social/@dataelemental "DataElemental Mastodon profile")
[![Mastodon: @brianary@mastodon.spotek.io](https://badgen.net/mastodon/follow/brianary@mastodon.spotek.io?icon=mastodon)](https://mastodon.spotek.io/@brianary "Mastodon profile")

[pester.yml]: https://github.com/brianary/scripts/actions/workflows/pester.yml "Pester test run history"

This repo contains a collection of generally useful scripts (mostly Windows PowerShell).

See [PS5](PS5) for legacy scripts, [syscfg](syscfg) for single-use system config scripts.

PowerShell Scripts
------------------
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
		Where-Object {!(Test-Path "$PSScriptRoot\$(Split-Path $_.Name -LeafBase)" -Type Leaf)} |
		Remove-Item
	Write-Progress 'Export PowerShell script help pages' 'Updating script docs'
	Update-MarkdownHelp $PSScriptRoot\docs\*.ps1.md -ErrorAction Ignore |Write-Verbose
	Write-Progress 'Export PowerShell script help pages' 'Adding docs for new scripts'
	Get-Item $PSScriptRoot\*.ps1 |
		Where-Object {!(Test-Path "$PSScriptRoot\$($_.Name).md" -Type Leaf)} |
		ForEach-Object {New-MarkdownHelp -Command $_.Name -OutputFolder docs -ErrorAction Ignore} |
		Write-Verbose
	$Local:OFS = [Environment]::NewLine
	return @"
<script data-goatcounter="https://webcoderscripts.goatcounter.com/count" async src="//gc.zgo.at/count.js"></script>

[![Pester tests status](https://github.com/brianary/scripts/actions/workflows/pester.yml/badge.svg)][pester.yml]
[![Pester tests results](https://gist.githubusercontent.com/brianary/4642e5c804aa1b40738def5a7c03607a/raw/badge.svg)][pester.yml]
[![Pester tests coverage]($(Get-PesterCoverageBadge -UseLines))](https://github.com/brianary/scripts/tree/main/test)
[![GitHub license badge](https://badgen.net/github/license/brianary/Scripts?icon=github)](https://mit-license.org/ "MIT License")
[![GitHub stars badge](https://badgen.net/github/stars/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/stargazers "Stars")
[![GitHub watchers badge](https://badgen.net/github/watchers/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/watchers "Watchers")
[![GitHub forks badge](https://badgen.net/github/forks/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/network/members "Forks")
[![GitHub issues badge](https://badgen.net/github/open-issues/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/issues "Issues")
[![GitHub commits badge](https://badgen.net/github/commits/brianary/Scripts/main?icon=git)](https://github.com/brianary/scripts/commits/main "Commits")
[![GitHub last commit badge](https://badgen.net/github/last-commit/brianary/Scripts/main?icon=git)](https://github.com/brianary/scripts/commits/main "Last commit")
[![Mastodon: @dataelemental@mastodon.social](https://badgen.net/badge/@dataelemental/@mastodon.social/blue?icon=mastodon)](https://mastodon.social/@dataelemental "DataElemental Mastodon profile")
[![Mastodon: @brianary@mastodon.spotek.io](https://badgen.net/mastodon/follow/brianary@mastodon.spotek.io?icon=mastodon)](https://mastodon.spotek.io/@brianary "brianary Mastodon profile")

[pester.yml]: https://github.com/brianary/scripts/actions/workflows/pester.yml "Pester test run history"

Scripts from the [Scripts](https://github.com/brianary/Scripts/) repo.

$(Format-PSScripts -Extension '.md' -entities)
"@ |Out-File docs\index.md
	Write-Progress 'Export PowerShell script help pages' -Completed
}

Format-Readme |Out-File $PSScriptRoot\README.md -Encoding utf8 -Width ([int]::MaxValue)
Format-TestsReadme |Out-File $PSScriptRoot\test\README.md -Encoding utf8 -Width ([int]::MaxValue)
Export-PSScriptPages
if($Commit) {git add -A ; git commit -m "$(Get-Unicode.ps1 0x1F4DD) Update readme"}
