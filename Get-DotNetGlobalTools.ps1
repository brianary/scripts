<#
.SYNOPSIS
Returns a list of global dotnet tools.

.FUNCTIONALITY
DotNet
#>

#Requires -Version 3
[CmdletBinding()] Param()

Use-Command.ps1 dotnet "$env:ProgramFiles\dotnet\dotnet.exe" -cinst dotnet-sdk

foreach($line in dotnet tool list -g |Where-Object {$_ -match '^\S+\s+\d+(?:\.\d+)+\b'})
{
	$package,$version,$commands = $line -split '\s\s+',3
	[pscustomobject]@{
		PackageName = $package
		Version     = try{[semver]$version}catch{try{[version]$version}catch{$version}};
		Commands    = $commands
	}
}
