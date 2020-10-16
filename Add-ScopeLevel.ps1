<#
.Synopsis
	Convert a scope level to account for another call stack level.

.Parameter Scope
	The requested scope from the caller of the caller of this script.

.Link
	Stap-ThrowError.ps1

.link
	Get-PSCallStack

.Example
	Add-ScopeLevel.ps1 Local

	1

.Example
	Add-ScopeLevel.ps1 3

	4

.Example
	Add-ScopeLevel.ps1 Global

	Global
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Scope
)
if($Scope -match '\A\d+\z') {return 1+[int]$Scope}
switch($Scope)
{
	Global {'Global'}
	Local {1}
	Private {1}
	Script
	{
		$stack = Get-PSCallStack
		for($i = 2; $i -lt $stack.Length; $i++)
		{
			if($stack[$i].Command -and $stack[$i].FunctionName -like '<ScriptBlock>*') {return $i-1}
		}
		Stop-ThrowError.ps1 'Unable to find Script scope' -Argument Scope
	}
}
