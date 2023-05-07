<#
.SYNOPSIS
Convert a scope level to account for another call stack level.

.DESCRIPTION
For scripts that need to get or set a variable of a specific scope so that it disappears at
the end of a block/function/script, or so that it persists globally, this calculates the
additional call level added by that script.

.INPUTS
System.String containing the desired level.

.OUTPUTS
System.String containing the calculated level (Global or an integer).

.LINK
Stop-ThrowError.ps1

.LINK
Get-PSCallStack

.LINK
about_Scopes

.FUNCTIONALITY
PowerShell

.EXAMPLE
Add-ScopeLevel.ps1 Local

1

.EXAMPLE
Add-ScopeLevel.ps1 3

4

.EXAMPLE
Add-ScopeLevel.ps1 Global

Global
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# The requested scope from the caller of the caller of this script.
# Global, Local, Private, Script, or a positive integer.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Scope
)
Process
{
	if($Scope -match '\A\d+\z') {return "$(1+[int]$Scope)"}
	switch($Scope)
	{
		Global  {return 'Global'}
		Local   {return '1'}
		Private {return '1'}
		Script
		{
			$stack = Get-PSCallStack
			for($i = 2; $i -lt $stack.Length; $i++)
			{
				if($stack[$i].Command -and $stack[$i].FunctionName -like '<ScriptBlock>*') {return "$($i-1)"}
			}
			Stop-ThrowError.ps1 'Unable to find Script scope' -Argument Scope
		}
	}
}

