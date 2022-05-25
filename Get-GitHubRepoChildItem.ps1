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
.\Get-GitHubRepoChildItem.ps1 -Path src -AlternatePath / -Filter LICENSE -File -OwnerName PowerShell -RepositoryName PSScriptAnalyzer

Tries to look within the src/ folder in the repo for LICENSE, or the root if src/ doesn't exist.
#>

#Requires -Version 7
#Requires -Modules PowerShellForGitHub
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
[string] $BranchName
)
Begin
{
    function Get-PathContentOrAlternate
    {
        [CmdletBinding()] Param(
        [Parameter(ValueFromPipelineByPropertyName)][psobject] $OwnerName,
        [Parameter(ValueFromPipelineByPropertyName)][string] $RepositoryName,
        [string] $Path,
        [string] $Branch,
        [string] $AlternatePath
        )
        [void]$PSBoundParameters.Remove('AlternatePath')
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
    Write-Verbose "$PSCommandPath $($PSBoundParameters |ConvertTo-Json -Compress)"
    if($OwnerName -isnot [string]) {$PSBoundParameters['OwnerName'] = $OwnerName = $OwnerName.UserName}
    $entryType = if($File -and $Directory) {''} elseif($File) {'file'} elseif($Directory) {'dir'} else {'*'}
    $contentSpec = @{
        OwnerName = $OwnerName
        RepositoryName = $RepositoryName
        Path = $Path
        AlternatePath = $AlternatePath
    }
    if($BranchName) {$contentSpec += @{BranchName=$BranchName}}
    Write-Progress "Searching $OwnerName/$RepositoryName $BranchName" ( $Path ? $Path : '/' )
    $content = Get-PathContentOrAlternate @contentSpec
    if($content.type -eq 'file')
    {
        if($content.type -like $entryType -and $content.name -like $Filter -and $content.name -notlike $Exclude) {return $content}
        else {return}
    }
    if($Recurse)
    {
        $content.entries |
            Where-Object {$_.type -eq 'dir' -and $_.name -notlike $Exclude} |
            ForEach-Object {& $PSCommandPath -Path $_.path -Filter $Filter -Exclude $Exclude -Recurse -File:$File `
                -Directory:$Directory -OwnerName $OwnerName -RepositoryName $RepositoryName -BranchName $BranchName}
    }
    Write-Progress "Searching $OwnerName/$RepositoryName $BranchName" -Completed
    return $content.entries |
        Where-Object {$_.type -like $entryType -and $_.name -like $Filter -and $_.name -notlike $Exclude}
}
