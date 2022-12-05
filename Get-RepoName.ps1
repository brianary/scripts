<#
.SYNOPSIS
Gets the name of the repo.

.INPUTS
Objects with System.String Path or FullName properties.

.OUTPUTS
System.String of the repo name (the final segment of the first remote location).

.FUNCTIONALITY
Git and GitHub

.EXAMPLE
Get-RepoName.ps1
#>

[CmdletBinding()][OutputType([string])] Param(
# The path to the git repo to get the name for.
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path = $PWD.Path
)
Begin { Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -cinst git }
Process
{
    if(!(Test-Path $Path -Type Container)) {Stop-ThrowError.ps1 "The path $Path was not found." -Argument Path}
    try
    {
        Push-Location $Path
        git status |Out-Null
        if(!$?) {Stop-ThrowError.ps1 "The path $Path is not a git repo."-Argument Path}
        $remote = git remote |select -First 1
        if($remote) {return ([uri](git remote get-url $remote)).Segments[-1] -replace '\.git\z',''}
        else {return [io.path]::GetFileName($Path)}
    }
    finally {Pop-Location}
}
