<#
.SYNOPSIS
Rename a git repository branch.

.LINK
https://docs.github.com/en/github/administering-a-repository/managing-branches-in-your-repository/renaming-a-branch#updating-a-local-clone-after-a-branch-name-changes

.LINK
https://github.com/github/renaming

.LINK
Use-Command.ps1

.EXAMPLE
Rename-GitHubLocalBranch.ps1 master main

Rename the master branch to main.
#>

#Requires -Version 3
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
# The new branch name.
[Parameter(Position=0,Mandatory=$true)][string] $NewName
)

if(!$PSCmdlet.ShouldContinue('Have you renamed the branch in the GitHub UI?','GitHub Status'))
{
	Write-Host 'Rename the branch via the GitHub UI before running this script.'
	if((Get-Command gh -CommandType Application -ErrorAction SilentlyContinue)) {gh browse}
	Start-Process 'https://docs.github.com/en/github/administering-a-repository/managing-branches-in-your-repository/renaming-a-branch#renaming-a-branch'
	return
}

$oldName = git rev-parse --abbrev-ref HEAD
if(!$PSCmdlet.ShouldProcess("$oldName branch","rename to $NewName")) {return}

Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -choco git
Write-Verbose "git branch -m $oldName $NewName"
git branch -m $oldName $NewName
Write-Verbose "git fetch origin"
git fetch origin
Write-Verbose "git branch -u origin/$NewName $NewName"
git branch -u "origin/$NewName" $NewName
Write-Verbose 'git remote set-head origin -a'
git remote set-head origin -a
Write-Verbose 'git remote prune origin'
git remote prune origin
