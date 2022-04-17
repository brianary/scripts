<#
.SYNOPSIS
Gets the SHA-1 hash of the first commit of the current repo.

.OUTPUTS
System.String containing the SHA-1 hash of this repo's first commit.

.LINK
Use-Command.ps1

.EXAMPLE
Get-GitFirstCommit.ps1

1fde7af20e8560c720d42227495e8d15459aafa4
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param()
Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -choco git
git log --max-parents=0 --format=format:%H HEAD
