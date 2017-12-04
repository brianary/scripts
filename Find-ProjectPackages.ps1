<#
.Synopsis
    Find modules used in projects.

.Parameter PackageName
    The name of a package to search for.
    Wildcards (as supported by -like) are allowed.

.Parameter Path
    The path of a folder to search within.
    Uses the current working directory ($PWD) by default.

.Parameter MinVersion
    The minimum (inclusive) version of the package to return.

.Parameter MaxVersion
    The maximum (inclusive) version of the package to return.

.Inputs
    System.String containing a package name (wildcards supported).

.Outputs
    System.Management.Automation.PSObject[] each with properties for the Name, 
    Version, and File of packages found.

.Link
    Select-Xml

.Link
    ConvertFrom-Json

.Example
    Find-ProjectModule.ps1 jQuery*


    Name               Version File
    ----               ------- ----
    jquery.datatables  1.10.9  C:\Repo\packages.config
    jQuery             1.7     C:\Repo\packages.config
    jQuery             1.8.3   C:\OtherRepo\packages.config
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject[]])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$PackageName,
[string]$Path = $PWD,
[version]$MinVersion,
[version]$MaxVersion
)
Begin
{
    function New-PackageInfo([string]$name,[string]$version,[string]$file)
    {
        New-Object psobject -Property ([ordered]@{Name=$name;Version=$version;File=$file})
    }
    function Compare-Version([string]$version)
    {
        if(!$MinVersion -and !$MaxVersion) {return $true}
        if(!($version -match '(?<Version>\b\d+\.\d+(?:\.\d+)?)')) {Write-Warning "Can't parse version $version"; return $true}
        $v = [version]$Matches.Version
        if(!$MaxVersion) {return $v -ge $MinVersion}
        elseif(!$MinVersion) {return $v -le $MaxVersion}
        else {return ($v -ge $MinVersion) -and ($v -le $MaxVersion)}
    }
    $action = 'Find Project Packages'
    Write-Progress $action 'Getting proj package lists' -PercentComplete 0
    [string[]]$projFiles = Get-ChildItem $Path -Recurse -Filter *proj |% FullName
    if(!$projFiles) {[string[]]$projFiles = @()}
    Write-Verbose "Found $($projFiles.Length) *proj files."
    Write-Progress $action 'Getting NuGet package lists' -PercentComplete 15
    [string[]]$nugetFiles = Get-ChildItem $Path -Recurse -Filter packages.config |% FullName
    if(!$nugetFiles) {[string[]]$nugetFiles = @()}
    Write-Verbose "Found $($nugetFiles.Length) packages.config files."
    Write-Progress $action 'Getting npm package lists' -PercentComplete 30
    [string[]]$npmFiles   = Get-ChildItem $Path -Recurse -Filter package.json |% FullName
    if(!$npmFiles) {[string[]]$npmFiles = @()}
    Write-Verbose "Found $($npmFiles.Length) package.json files."
    Write-Progress $action 'Getting paket.lock package lists' -PercentComplete 45
    [string[]]$paketFiles   = Get-ChildItem $Path -Recurse -Filter paket.lock |% FullName
    if(!$paketFiles) {[string[]]$paketFiles = @()}
    Write-Verbose "Found $($paketFiles.Length) paket.lock files."
    $max = $projFiles.Length + $nugetFiles.Length + $npmFiles.Length + $paketFiles.Length
    Write-Verbose "Found $max package files."
    if(!$max) {Write-Error "No package lists found!"; return}
    $packages,$i = (New-Object Collections.ArrayList),0
    foreach($file in $projFiles)
    {
        Write-Verbose "Parsing $file"
        Write-Progress $action "Parsing *proj package files: found $($projFiles.Count)" -CurrentOperation $file -PercentComplete (10*$i++/$max+60)
        $p = Select-Xml //msbuild:HintPath $file -Namespace @{'msbuild'='http://schemas.microsoft.com/developer/msbuild/2003'}
        if(!$p) {Write-Verbose "No packages found in $file"; continue}
        [void]$packages.AddRange([object[]]( $p |% {$dll = Join-Path (Split-Path $_.Path) $_.Node.InnerText; @{
            name    = $_.Node.ParentNode.Attributes['Include'].Value
            version = $(if(Test-Path $dll -PathType Leaf) {ls $dll |% VersionInfo |% ProductVersion})
            file    = $file
        }} |% {New-PackageInfo @_} ))
    }
    foreach($file in $nugetFiles)
    {
        Write-Verbose "Parsing $file"
        Write-Progress $action "Parsing NuGet package files: found $($nugetFiles.Count)" -CurrentOperation $file -PercentComplete (10*$i++/$max+70)
        $p = Select-Xml /packages/package $file |% Node
        if(!$p) {Write-Verbose "No packages found in $file"; continue}
        [void]$packages.AddRange([object[]]( $p |% {@{
            name    = $_.id
            version = $_.version
            file    = $file
        }} |% {New-PackageInfo @_} ))
    }
    foreach($file in $npmFiles)
    {
        Write-Verbose "Parsing $file"
        Write-Progress $action "Parsing npm package files: found $($npmFiles.Count)" -CurrentOperation $file -PercentComplete (10*$i++/$max+80)
        $j = ConvertFrom-Json (Get-Content $file -Raw)
        if(!(Get-Member -InputObject $j -Name dependencies)) {Write-Verbose "No dependencies found in $file"; continue}
        $p = Get-Member -InputObject $j.dependencies -MemberType NoteProperty |% Name
        if(!$p) {Write-Verbose "No packages found in $file"; continue}
        [void]$packages.AddRange([object[]]( $p |% {@{
            name    = $_
            version = $j.dependencies.$_
            file    = $file
        }} |% {New-PackageInfo @_} ))
    }
    foreach($file in $paketFiles)
    {
        Write-Verbose "Parsing $file"
        Write-Progress $action "Parsing paket.lock package files: found $($paketFiles.Count)" -CurrentOperation $file -PercentComplete (10*$i++/$max+90)
        $lockpattern = '\A\s{4}(?<Name>\w\S+)\s\((?:>= )?(?<Version>\d+(?:\.\d+)+)\b'
        $p = Get-Content $file |% {if($_ -match $lockpattern){[pscustomobject]@{Name=$Matches.Name;Version=$Matches.Version}}}
        if(!$p) {Write-Verbose "No packages found in $file"; continue}
        [void]$packages.AddRange([object[]]( $p |% {@{
            name    = $_.Name
            version = $_.Version
            file    = $file
        }} |% {New-PackageInfo @_} ))
    }
    $max = $packages.Count
}
Process
{
    $packages |
        ? {$_.Name -like $PackageName} |
        ? {Compare-Version $_.Version}
}
