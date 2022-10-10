<#
.SYNOPSIS
Creates a new Pester testing script for a given script.
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The script to generate tests for.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[ValidateScript({Test-Path $_ -Type Leaf})][string] $Script,
# The directory to generate tests in.
[ValidateScript({Test-Path $_ -Type Container})][string] $Directory = 'test',
# Overwrite an existing tests file.
[switch] $Force
)
Begin
{
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
		$Local:OFS = $NL
		return @"
<#
.SYNOPSIS
Tests $Synopsis
#>

Describe '$Synopsis'{
	BeforeAll {
		`$scriptsdir,`$sep = (Split-Path `$PSScriptRoot),[io.path]::PathSeparator
		if(`$scriptsdir -notin (`$env:Path -split `$sep)) {`$env:Path += "`$sep`$scriptsdir"}
	}
	Context 'Examples' -Tag example {
$($Examples.example |Format-ExampleTest)
	}
$($CmdInfo.ParameterSets |Where-Object Name -ne __AllParameterSets |Format-ParameterSetContext)
}
"@
	}
}
Process
{
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
}
