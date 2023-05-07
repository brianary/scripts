<#
.SYNOPSIS
Returns a list of global dotnet tools.

.FUNCTIONALITY
DotNet

#>

#Requires -Version 3
[CmdletBinding()] Param(
# The name of the tool to search for.
[Parameter(Position=0,Mandatory=$true)][string] $Name
)

Use-Command.ps1 dotnet "$env:ProgramFiles\dotnet\dotnet.exe" -cinst dotnet-sdk

foreach($line in dotnet tool search $Name |Where-Object {$_ -match '^\S+\s+\d+(?:\.\d+)+\b'})
{
	$package,$version,$authors,$downloads,$verified = $line -split '\s\s+',5
	[pscustomobject]@{
		PackageName = $package
		Version     = try{[semver]$version}catch{try{[version]$version}catch{$version}};
		Authors     = $authors
		Downloads   = $downloads
		Verified    = $verified.Trim() -eq 'x'
	}
}
