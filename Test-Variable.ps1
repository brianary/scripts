<#
.Synopsis
	Indicates whether a variable has been defined.

.Parameter Name
    A variable name to test the existence of.

.Inputs
    System.String name of a variable.

.Outputs
    System.Boolean indicating whether the variable name is defined.

.Link
    Get-Variable

.Example
	Test-Variable.ps1 true

    True

.Example
	'PWD','PID' |Test-Variable.ps1 -Scope Global

    True
    True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$Name,
[Parameter(Position=1)]$Scope = '1'
)
Process {[bool](Get-Variable -Name $Name -Scope $Scope -ErrorAction SilentlyContinue)}
