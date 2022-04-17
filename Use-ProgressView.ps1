<#
.SYNOPSIS
Sets the progress bar display view.

.PARAMETER View
The progress view to use.

.LINK
about_ANSI_Terminals

.EXAMPLE
Use-ProgressView.ps1 Classic

Restores the Windows PowerShell 5.x-style top progress banner for Write-Progress.
#>

#Requires -Version 7.2
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][System.Management.Automation.ProgressView] $View
)
$PSStyle.Progress.View = $View
