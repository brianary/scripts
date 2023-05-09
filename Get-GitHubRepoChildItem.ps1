<#
.SYNOPSIS
Gets the items and child items in one or more specified locations.

.EXAMPLE
Get-GitHubRepoChildItem.ps1 -Filter *.csproj -Recurse -File -OwnerName PowerShell -RepositoryName PSScriptAnalyzer |Format-Table name,size,path -AutoSize

name           size path
----           ---- ----
Engine.csproj  3679 Engine/Engine.csproj
Rules.csproj   2586 Rules/Rules.csproj

.EXAMPLE
Get-GitHubRepoChildItem.ps1 -Path src -AlternatePath / -Filter LICENSE -File -OwnerName PowerShell -RepositoryName PSScriptAnalyzer

name         : LICENSE
path         : LICENSE
sha          : cec380d8ef7f7a1ad3ff9ef2356a88a13a78b491
size         : 1089
url          : https://api.github.com/repos/PowerShell/PSScriptAnalyzer/contents/LICENSE?ref=master
html_url     : https://github.com/PowerShell/PSScriptAnalyzer/blob/master/LICENSE
git_url      : https://api.github.com/repos/PowerShell/PSScriptAnalyzer/git/blobs/cec380d8ef7f7a1ad3ff9ef2356a88a13a78b491
download_url : https://raw.githubusercontent.com/PowerShell/PSScriptAnalyzer/master/LICENSE
type         : file
_links       : @{self=https://api.github.com/repos/PowerShell/PSScriptAnalyzer/contents/LICENSE?ref=master; git=https://api.github.com/repos/PowerShell/PSScriptAnalyzer/git/blobs/cec380d8ef7f7a1ad3ff9ef2356a88a13a78b491; html=https://github.com/PowerShell/PSScriptAnalyzer/blob/master/LICENSE}
#>

#Requires -Version 7
#Requires -Modules PowerShellForGitHub
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars','',
Justification='Using a global variable to cache responses, to avoid abusive API iteration.')]
[CmdletBinding()] Param(
# The path for which to retrieve contents.
[Parameter(Position=0)][string] $Path = '',
# Specifies a wildcard pattern to filter matches against.
[string] $Filter = '*',
# Specifies a wildcard pattern to exclude matches against.
[string] $Exclude = '',
# An alternate path to retrieve if the primary Path isn't found.
[string] $AlternatePath,
# Indicates subdirectories should be searched.
[switch] $Recurse,
# Indicates that only files should be returned.
[switch] $File,
# Indicates that only directories should be returned.
[switch] $Directory,
# Owner of the repository.
[Parameter(ValueFromPipelineByPropertyName)][psobject] $OwnerName,
# Name of the repository.
[Parameter(ValueFromPipelineByPropertyName)][Alias('Name')][string] $RepositoryName,
# The branch, or defaults to the default branch of not specified.
[string] $BranchName,
# Ignores any cached result and re-queries the GitHub API.
[switch] $Force
)
Begin
{
    if(!(Get-Variable GitHubRepoContents -Scope Global -ErrorAction SilentlyContinue)) {$Global:GitHubRepoContents = @{}}
    function Get-PathContentOrAlternate
    {
        [CmdletBinding()] Param(
        [psobject] $OwnerName,
        [string] $RepositoryName,
        [string] $Path,
        [string] $Branch,
        [string] $AlternatePath
        )
        [void]$PSBoundParameters.Remove('AlternatePath')
        if($Path -in '','.','/') {[void]$PSBoundParameters.Remove('Path')}
        try {return Get-GitHubContent @PSBoundParameters}
        catch [Microsoft.PowerShell.Commands.HttpResponseException]
        {
            Write-Verbose "Could not find path $Path in $OwnerName/$RepositoryName"
            if($_.Exception.Response.StatusCode -ne 404 -or $AlternatePath -eq $null) {throw}
            if($AlternatePath -in '','.','/') {[void]$PSBoundParameters.Remove('Path')}
            else {$PSBoundParameters['Path'] = $AlternatePath}
            return Get-GitHubContent @PSBoundParameters
        }
    }
}
Process
{
    Write-Verbose $MyInvocation.Line
    if($OwnerName -isnot [string]) {$PSBoundParameters['OwnerName'] = $OwnerName = $OwnerName.UserName}
    $repoContext, $searchContext = "$OwnerName/$RepositoryName/$BranchName",
        "$Path|$AlternatePath|$Filter|$Exclude|$Recurse|$File|$Directory"
    if(!$Global:GitHubRepoContents.ContainsKey($repoContext))
    {
        $Global:GitHubRepoContents[$repoContext] = @{}
    }
    elseif(!$Force -and $Global:GitHubRepoContents[$repoContext].ContainsKey($searchContext))
    {
        return $Global:GitHubRepoContents[$repoContext][$searchContext]
    }
    $entryType = if($File -and $Directory) {''} elseif($File) {'file'} elseif($Directory) {'dir'} else {'*'}
    $contentSpec = @{
        OwnerName = $OwnerName
        RepositoryName = $RepositoryName
        Path = $Path
        AlternatePath = $AlternatePath
    }
    if($BranchName) {$contentSpec += @{BranchName=$BranchName}}
    Write-Progress "Searching $OwnerName/$RepositoryName $BranchName" ( $Path ? $Path : '/' )
    if(!$Force -and $Global:GitHubRepoContents[$repoContext].ContainsKey("$Path|$AlternatePath"))
    {
        $content = $Global:GitHubRepoContents[$repoContext]["$Path|$AlternatePath"]
    }
    else
    {
        $content = Get-PathContentOrAlternate @contentSpec
        $Global:GitHubRepoContents[$repoContext]["$Path|$AlternatePath"] = $content
    }
    if($content.type -eq 'file')
    {
        if($content.type -notlike $entryType -or $content.name -notlike $Filter -or $content.name -like $Exclude) {return}
        $Global:GitHubRepoContents[$repoContext][$searchContext] = $content
        return $content
    }
    $found = @($content.entries |
        Where-Object {$_.type -like $entryType -and $_.name -like $Filter -and $_.name -notlike $Exclude})
    if($Recurse)
    {
        $found += @($content.entries |
            Where-Object {$_.type -eq 'dir' -and $_.name -notlike $Exclude} |
            ForEach-Object {& $PSCommandPath -Path $_.path -Filter $Filter -Exclude $Exclude -Recurse -File:$File `
                -Directory:$Directory -OwnerName $OwnerName -RepositoryName $RepositoryName -BranchName $BranchName})
    }
    $Global:GitHubRepoContents[$repoContext][$searchContext] = $found
    Write-Progress "Searching $OwnerName/$RepositoryName $BranchName" -Completed
    return $found
}
