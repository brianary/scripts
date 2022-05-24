<#
.SYNOPSIS
Gets the items and child items in one or more specified locations.

.EXAMPLE
.\Get-GitHubRepoChildItem.ps1 -Filter *.csproj -Recurse -File -OwnerName PowerShell -RepositoryName PSScriptAnalyzer |Format-Table name,size,path -AutoSize

name           size path
----           ---- ----
Engine.csproj  3679 Engine/Engine.csproj
Rules.csproj   2586 Rules/Rules.csproj
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
# Indicates subdirectories should be searched.
[switch] $Recurse,
# Indicates that only files should be returned.
[switch] $File,
# Indicates that only directories should be returned.
[switch] $Directory,
# Owner of the repository.
[Parameter(ValueFromPipelineByPropertyName)][psobject] $OwnerName,
# Name of the repository.
[Parameter(ValueFromPipelineByPropertyName)][string] $RepositoryName,
# The branch, or defaults to the default branch of not specified.
[string] $BranchName
)
Process
{
    Write-Verbose "$PSCommandPath $($PSBoundParameters |ConvertTo-Json -Compress)"
    $entryType = if($File -and $Directory) {''} elseif($File) {'file'} elseif($Directory) {'dir'} else {'*'}
    $contentSpec = @{
        OwnerName = $OwnerName -is [string] ? $OwnerName : $OwnerName.UserName
        RepositoryName = $RepositoryName
        Path = $Path
    }
    if($BranchName) {$contentSpec += @{BranchName=$BranchName}}
    Write-Verbose "Get-GitHubContent $($contentSpec |ConvertTo-Json -Compress)"
    $content = Get-GitHubContent @contentSpec
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
    return $content.entries |
        Where-Object {$_.type -like $entryType -and $_.name -like $Filter -and $_.name -notlike $Exclude}
}
