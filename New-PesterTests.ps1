<#
.SYNOPSIS
Creates a new Pester testing script from a script's examples and parameter sets.

.FUNCTIONALITY
Scripts

.LINK
Stop-ThrowError.ps1

.EXAMPLE
New-PesterTests.ps1 New-PesterTests.ps1

Creates .\test\New-PesterTests.Tests.ps1 with some boilerplate Pester code.
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The script to generate tests for.
[Parameter(ParameterSetName='Script',Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[ValidateScript({Test-Path $_ -Type Leaf})][string] $Script,
# The directory to generate tests in.
[ValidateScript({Test-Path $_ -Type Container})][string] $Directory = 'test',
# Overwrite an existing tests file.
[Parameter(ParameterSetName='Script')][switch] $Force,
# Indicates that the next script that's missing a test script file should have one created.
[Parameter(ParameterSetName='Next',Mandatory=$true)][switch] $Next
)
Begin
{
	if($PSCmdlet.ParameterSetName -eq 'Next')
	{
		if(!$Next) {return}
		else
		{
			$nextScript = Get-Item *.ps1 |
				Where-Object {!(Join-Path $Directory ([io.path]::ChangeExtension($_.Name,'Tests.ps1')) |Test-Path -Type Leaf)} |
				Select-Object -First 1
			if(!$nextScript)
			{
				Write-Info.ps1 'Congratulations, all of the scripts in this directory have test files.' -ForegroundColor Green
				return
			}
			else
			{
				Write-Info.ps1 "Creating new tests script for $nextScript" -ForegroundColor Green
				return &$PSCommandPath -Script $nextScript -Directory $Directory
			}
		}
	}
	Set-Variable NL ([Environment]::NewLine) -Scope Script -Option Constant

	filter Format-ExampleTest
	{
		Param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Title,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][psobject[]] $Introduction,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Code,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][psobject[]] $Remarks
		)
		$cmdtext = (($Introduction |Where-Object Text -notin 'PS > ',' ','',$null |ForEach-Object Text) -join $NL) + $Code
		$output = ($Remarks |Where-Object {$_.Text} |ForEach-Object Text) -join $NL
		return @"
		It "$($Title.Trim(' -'))" -Skip {
			$cmdtext |Should -BeExactly @"
$output
$('"@')
		}
"@
	}

	filter Format-ParameterSetContext
	{
		Param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][ValidateNotNullOrEmpty()][string] $Name
		)
		if([string]::IsNullOrWhiteSpace($Name)) {return}
		return @"
	Context '$Name' -Tag $Name {
		It "test" -Skip {
			1 |Should -Be 1
		}
	}
"@
	}

	filter Format-ScriptPesterTests
	{
		Param(
		[Parameter(Position=0,Mandatory=$true)][string] $Name,
		[Parameter(Position=0,Mandatory=$true)][Management.Automation.CommandInfo] $CmdInfo,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Synopsis,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][psobject[]] $Examples
		)
		$shortname = [io.path]::GetFileNameWithoutExtension($Name)
		$Local:OFS = $NL
		return @"
<#
.SYNOPSIS
Tests $Synopsis
#>

Describe '$shortname' -Tag $shortname {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		`$scriptsdir,`$sep = (Split-Path `$PSScriptRoot),[io.path]::PathSeparator
		`$ScriptName = Join-Path `$scriptsdir $shortname.ps1
		if(`$scriptsdir -notin (`$env:Path -split `$sep)) {`$env:Path += "`$sep`$scriptsdir"}
	}
	Context '$($Synopsis -replace "'","''")' -Tag Example {
$($Examples.example |Format-ExampleTest)
	}
$($CmdInfo.ParameterSets |Where-Object Name -ne __AllParameterSets |Format-ParameterSetContext)
}
"@
	}
}
Process
{
	if($PSCmdlet.ParameterSetName -eq 'Next') {return}
	$name = Split-Path $Script -Leaf
	$cmd = Resolve-Path $Script |Get-Command
	$testfile = Join-Path $Directory ([io.path]::ChangeExtension($name,'Tests.ps1'))
	if((Test-Path $testfile -Type Leaf) -and !$Force)
	{
		Stop-ThrowError.ps1 "File '$testfile' already exists" -Argument Script
	}
	Get-Help (Resolve-Path $Script) |
		Format-ScriptPesterTests -Name $name -CmdInfo $cmd |
		Out-File $testfile -Encoding utf8BOM
	if((Get-Variable psEditor -Scope Global -ErrorAction Ignore) -and (Test-Path $testfile -Type Leaf))
	{
		$psEditor.Workspace.OpenFile($Script, $false)
		$psEditor.Workspace.OpenFile($testfile, $false)
	}
}
