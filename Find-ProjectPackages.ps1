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

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$PackageName,
[string]$Path = $PWD,
[version]$MinVersion,
[version]$MaxVersion
)
Begin
{
    $action = 'Find Project Packages'
    Write-Progress $action 'Getting NuGet package lists' -PercentComplete 0
    [string[]]$nugetFiles = Get-ChildItem $Path -Recurse -Filter packages.config |% FullName
    if(!$nugetFiles) {[string[]]$nugetFiles = @()}
    Write-Verbose "Found $($nugetFiles.Length) packages.config files."
    Write-Progress $action 'Getting npm package lists' -PercentComplete 25
    [string[]]$npmFiles   = Get-ChildItem $Path -Recurse -Filter package.json |% FullName
    if(!$npmFiles) {[string[]]$npmFiles = @()}
    Write-Verbose "Found $($npmFiles.Length) package.json files."
    #TODO: Also search paket.dependencies and/or paket.lock
    $max = $nugetFiles.Length + $npmFiles.Length
    Write-Verbose "Found $max package files."
    if(!$max) {Write-Error "No package lists found!"; return}
    $packages,$i,$count = @{},0,0
    foreach($file in $nugetFiles)
    {
        Write-Verbose "Parsing $file"
        Write-Progress $action "Parsing package files: found $count" -CurrentOperation $file -PercentComplete (25*$i++/$max+50)
        $p = Select-Xml /packages/package $file |% Node
        if(!$p) {Write-Verbose "No packages found in $file"; continue}
        $packages.Add($file,@{})
        $p |% {[void]$packages.$file.Add($_.id,$_.version)}
        $count += $packages.$file.Count
    }
    foreach($file in $npmFiles)
    {
        Write-Verbose "Parsing $file"
        Write-Progress $action "Parsing package files: found $count" -CurrentOperation $file -PercentComplete (25*$i++/$max+50)
        $j = ConvertFrom-Json (Get-Content $file -Raw)
        if(!(Get-Member -InputObject $j -Name dependencies)) {Write-Verbose "No dependencies found in $file"; continue}
        $p = Get-Member -InputObject $j.dependencies -MemberType NoteProperty |% Name
        if(!$p) {Write-Verbose "No packages found in $file"; continue}
        $packages.Add($file,@{})
        $p |% {[void]$packages.$file.Add($_,$j.dependencies.$_)}
        $count += $packages.$file.Count
    }
    $max = $packages.Count
    function Compare-Version([string]$version)
    {
        if(!$MinVersion -and !$MaxVersion) {return $true}
        if(!($version -match '(?<Version>\b\d+\.\d+(?:\.\d+)?)')) {Write-Warning "Can't parse version $version"; return $true}
        $v = [version]$Matches.Version
        if(!$MaxVersion) {return $v -ge $MinVersion}
        elseif(!$MinVersion) {return $v -le $MaxVersion}
        else {return ($v -ge $MinVersion) -and ($v -le $MaxVersion)}
    }
}
Process
{
    $i = 0
    foreach($file in $packages.Keys)
    {
        Write-Verbose "Searching $file ($($packages.$file.Count) packages)"
        Write-Progress $action 'Searching packages' -CurrentOperation "$file ($($packages.$file.Count) packages)" -PercentComplete (25*$i++/$max+75)
        $packages.$file.Keys |
            ? {$_ -like $PackageName} |
            ? {Compare-Version $packages.$file.$_} |
            % {New-Object psobject -Property ([ordered]@{Name=$_;Version=$packages.$file.$_;File=$file})}
    }
    Write-Progress $action -Completed
}