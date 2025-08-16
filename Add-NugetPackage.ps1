<#
.SYNOPSIS
Loads a NuGet package DLL, downloading as needed.

.NOTES
Install-Package isn't working for arbitrary NuGet packages, so this allows us access the main DLL
assembly and types within the package.

.FUNCTIONALITY
PowerShell

.LINK
https://www.nuget.org/

.EXAMPLE
Add-NugetPackage.ps1 Serilog ; [Serilog.Core.Logger]::None -is [Serilog.ILogger]

True
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The name of the NuGet package to load.
[Parameter(Position=0,Mandatory=$true)][string] $PackageName,
# Use this type name to test whether the package was loaded.
[Parameter(Position=1)][string] $TypeName
)
Begin
{
    $Script:BaseDir = Join-Path ($IsWindows ? $env:LOCALAPPDATA : ($env:XDG_CACHE_HOME ?? "$(Resolve-Path ~/.cache)")) PSNuget
    $Script:BinDir = Join-Path $BaseDir bin
    $Script:LibDir = Join-Path $BaseDir lib
    if(!(Test-Path $BinDir -Type Container)) {New-Item $BinDir -Type Directory |Out-Null}
    if(!(Test-Path $LibDir -Type Container)) {New-Item $LibDir -Type Directory |Out-Null}
}
Process
{
    try {[void][type]$TypeName; return} catch {}
    $dll = Join-Path $BinDir "$PackageName.dll"
    if(([System.AppDomain]::CurrentDomain.GetAssemblies() |Where-Object Location -eq $dll))
    {
        try {[void][type]$TypeName} catch {Write-Warning "'$PackageName' was loaded, but type '$TypeName' was not found: $_"}
        return
    }
    if(Test-Path $dll -Type Leaf)
    {
        Add-Type -Path $dll
        try {[void][type]$TypeName} catch {Write-Warning "'$PackageName' was found and loaded, but type '$TypeName' was not found: $_"}
        return
    }
    $nuget = Join-Path $LibDir "$PackageName.nuget"
    if(!(Test-Path $nuget -Type Leaf)) {Invoke-WebRequest "https://www.nuget.org/api/v2/package/$PackageName" -OutFile $nuget}
    $dir = Join-Path $LibDir $PackageName
    if(!(Test-Path $dir -Type Container)) {Expand-Archive -Path $nuget -DestinationPath $dir}
    $libdll = Get-ChildItem $dir -Filter *.dll -Recurse |Select-Object -Last 1
    New-Item -Type HardLink -Path $dll -Value $libdll |Out-Null
    Add-Type -Path $dll
    try {[void][type]$TypeName} catch {Write-Warning "Unable to find type '$TypeName': $_"}
}
