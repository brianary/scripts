<#
.Synopsis
	Re-encodes Windows-1252 text that has been misinterpreted as UTF-8.

.Parameter InputObject
	The string containing encoding failures to fix.

.Inputs
	System.String containing encoding failures to fix.

.Outputs
	System.String containing the corrected string data.

.Example
	Repair-Encoding.ps1 'SmartQuotes Arenâ€™t'
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputObject
)
Process
{
	[Text.Encoding]::UTF8.GetString([Text.Encoding]::GetEncoding('Windows-1252').GetBytes($InputObject)).Normalize('FormKD')
}
