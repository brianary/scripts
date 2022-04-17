<#
.SYNOPSIS
Cleans up comment-based help blocks by fully unindenting and capitalizing dot keywords.

.INPUTS
An object with a Path or FullName property.

.EXAMPLE
Optimize-Help.ps1 Get-Thing.ps1

Unindents help and capitalizes dot keywords in Get-Thing.ps1
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The script to process.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)
Process
{
	[regex]::Replace((Get-Content $Path -Raw).TrimEnd(), '(?s)<#\s*(\.\w+.*?)#>',
		{[regex]::Replace(($args[0] -replace '(?m)^[\x09\x20]+',''), '(?m)^(\.\w+)\b', {"$($args[0])".ToUpper()} )}) |
		Out-File $Path utf8BOM
}
