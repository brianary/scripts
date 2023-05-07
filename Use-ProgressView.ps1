<#
.SYNOPSIS
Sets the progress bar display view.

.FUNCTIONALITY
PowerShell

.LINK
about_ANSI_Terminals

.EXAMPLE
Use-ProgressView.ps1 Classic

Restores the Windows PowerShell 5.x-style top progress banner for Write-Progress.
#>

#Requires -Version 7.2
[CmdletBinding()] Param(
# The progress view to use.
[Parameter(Position=0,Mandatory=$true)][System.Management.Automation.ProgressView] $View
)
$PSStyle.Progress.View = $View

