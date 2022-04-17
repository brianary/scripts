<#
.SYNOPSIS
Re-encodes Windows-1252 text that has been misinterpreted as UTF-8.

.PARAMETER InputObject
The string containing encoding failures to fix.

.INPUTS
System.String containing encoding failures to fix.

.OUTPUTS
System.String containing the corrected string data.

.EXAMPLE
Repair-Encoding.ps1 'SmartQuotes Arenâ€™t'

SmartQuotes Aren’t
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputObject
)
Process
{
	[Text.Encoding]::UTF8.GetString([Text.Encoding]::GetEncoding('Windows-1252').GetBytes($InputObject)).Normalize('FormKD')
}
