<#
.SYNOPSIS
Updates NuGet packages for a .NET solution or project.

.FUNCTIONALITY
DotNet

.LINK
Use-Command.ps1

.LINK
Write-Info.ps1

.EXAMPLE
Update-DotNetPackages.ps1 src Deprecated

A:/AzFnRepo/src/AzFnDemo/AzFnDemo.csproj: net6.0
A:/AzFnRepo/src/AzFnDemo/AzFnDemo.csproj: Microsoft.NET.Sdk.Functions [Deprecated] Other Legacy
A:/AzFnRepo/src/AzFnDemo/AzFnDemo.csproj: Upgrading 'Microsoft.NET.Sdk.Functions' from 4.1.0 to 4.6.0
WARNING: A:/AzFnRepo/src/AzFnDemo/AzFnDemo.csproj: Removing 1 duplicate 'Microsoft.NET.Sdk.Functions' entries
A:/AzFnRepo/src/AzFnDemo.Tests/AzFnDemo.Tests.csproj: up to date
A:/AzFnRepo/src/AzFnDemo.Core/AzFnDemo.Core.csproj: net6.0
A:/AzFnRepo/src/AzFnDemo.Core/AzFnDemo.Core.csproj: Microsoft.NET.Sdk.Functions [Deprecated] Other Legacy
A:/AzFnRepo/src/AzFnDemo.Core/AzFnDemo.Core.csproj: Upgrading 'Microsoft.NET.Sdk.Functions' from 4.1.0 to 4.6.0
WARNING: A:/AzFnRepo/src/AzFnDemo.Core/AzFnDemo.Core.csproj: Removing 1 duplicate 'Microsoft.NET.Sdk.Functions' entries
#>

#Requires -Version 7.3
[CmdletBinding()] Param(
# The path to a .sln or .??proj file, or a directory containing either.
[Parameter(Position=0,Mandatory=$true)][string] $Path,
<#
Specifies that packages should only be upgraded based why they are outdated:
* Vulnerable: Only upgrade packages with known security vulnerabilities.
* Deprecated: Only upgrade packages marked as discouraged for any reason.
* Outdated: Upgrade all packages.
#>
[Parameter(Position=1)][ValidateSet('Vulnerable','Deprecated','Outdated')][string] $Reason = 'Vulnerable',
# Packages to ignore when upgrading.
[Parameter(Position=2,ValueFromRemainingArguments=$true)][string[]] $SkipPackages = @()
)

filter Write-Vulnerability
{
    [CmdletBinding()] Param(
    [Parameter(Position=0,Mandatory=$true)][string] $Path,
    [Parameter(Position=1,Mandatory=$true)][string] $Id,
    [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $Severity,
    [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][uri] $AdvisoryUrl
    )
    Write-Info.ps1 "${Path}: $Id [$Severity] $AdvisoryUrl" -fg Magenta
}

filter Update-Package
{
    [CmdletBinding()] Param(
    [Parameter(Position=0,Mandatory=$true)][string] $Path,
    [Parameter(Position=1,Mandatory=$true)][xml] $Project,
    [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][ValidatePattern('\A\w+(\.\w+)*\z')][string] $Id,
    [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $RequestedVersion,
    [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $ResolvedVersion,
    [Parameter(ValueFromPipelineByPropertyName=$true)][string] $LatestVersion,
    [Parameter(ValueFromPipelineByPropertyName=$true)][pscustomobject[]] $Vulnerabilities,
    [Parameter(ValueFromPipelineByPropertyName=$true)][string[]] $DeprecationReasons
    )
    if($Id -in $SkipPackages) {Write-Info.ps1 "${Path}: Skipping '$Id' upgrade, keeping version $RequestedVersion" -fg Cyan; return}
    if($Vulnerabilities) {$Vulnerabilities |Write-Vulnerability -Path $Path -Id $Id}
    if($DeprecationReasons) {Write-Info.ps1 "${Path}: $Id [Deprecated] $DeprecationReasons" -fg DarkMagenta}
    if(!$LatestVersion)
    {
        $LatestVersion = @((dotnet package search $Id --exact-match --format json |
            Out-String |ConvertFrom-Json).searchResult.packages)[-1].version
    }
    [Xml.XmlElement] $first, [Xml.XmlElement[]] $extras = @($Project.SelectNodes("/Project/ItemGroup/PackageReference[@Include='$Id']"))
    if(!$first) {throw "Could not find '$Id' in $Path"}
    Write-Info.ps1 "${Path}: Upgrading '$Id' from $RequestedVersion to $LatestVersion" -fg Gray
    $first.SetAttribute('Version', $LatestVersion)
    if($extras)
    {
        Write-Warning "${Path}: Removing $($extras.Count) duplicate '$Id' entries"
        $extras |ForEach-Object {$_.ParentNode.RemoveChild($_)} |Out-Null
    }
}

filter Update-Project
{
    [CmdletBinding()] Param(
    [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $Path,
    [Parameter(ValueFromPipelineByPropertyName=$true)][pscustomobject[]] $Frameworks
    )
    if(!$Frameworks) {Write-Info.ps1 "${Path}: up to date" -fg Green; return}
    Write-Info.ps1 "${Path}: $($Frameworks.framework)" -fg Blue
    $Project = New-Object Xml.XmlDocument -Property @{PreserveWhitespace=$true}
    $Project.Load($Path)
    $Frameworks.topLevelPackages |Update-Package -Path $Path -Project $Project
    $Project.Save($Path)
}

Use-Command.ps1 dotnet "$env:ProgramFiles\dotnet\dotnet.exe" -ChocolateyPackage dotnet-sdk
dotnet restore $Path
$updates = dotnet list $Path package "--$($Reason.ToLower())" --format json |Out-String |ConvertFrom-Json
$updates.projects |Update-Project
dotnet clean $Path
dotnet restore $Path
