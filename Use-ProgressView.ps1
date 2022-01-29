<#
.Synopsis
	Sets the progress bar display view.

.Parameter View
	The progress view to use.

.Link
	about_ANSI_Terminals

.Example
	Use-ProgressView.ps1 Classic

	Restores the Windows PowerShell 5.x-style top progress banner for Write-Progress.
#>

#Requires -Version 7.2
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][System.Management.Automation.ProgressView] $View
)
$PSStyle.Progress.View = $View
