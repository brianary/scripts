<#
.Synopsis
    Gets the name of the repo.

.Parameter Path
	The path to the git repo to get the name for.

.Inputs
	Objects with System.String Path or FullName properties.

.Outputs
	System.String of the repo name (the final segment of the first remote location).

.Example
	Get-RepoName.ps1
#>

[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path = $PWD.Path
)
Begin { Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -cinst git }
Process
{
    if(!(Test-Path $Path -Type Container))
    {
        Stop-ThrowError.ps1 ArgumentException "The path $Path was not found.",
            'Path' InvalidArgument $Path 'BadDir'
    }
    try
    {
        Push-Location $Path
        git status |Out-Null
        if(!$?) {Stop-ThrowError.ps1 ArgumentException "The path $Path is not a git repo.",
            'Path' InvalidArgument $Path 'NotRepo'}
        $remote = git remote |select -First 1
        if($remote) {return ([uri](git remote get-url $remote)).Segments[-1] -replace '\.git\z',''}
        else {return [io.path]::GetFileName($Path)}
    }
    finally {Pop-Location}
}
