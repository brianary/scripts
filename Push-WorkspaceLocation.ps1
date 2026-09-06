<#
.SYNOPSIS
Pushes the current VS Code editor workspace location to the location stack.

.FUNCTIONALITY
VSCode

.LINK
Push-Location

.EXAMPLE
Push-WorkspaceLocation.ps1

Pushes the current directory onto the stack, and changes to the workspace directory.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param()
if(ModernConveniences\Test-Variable psEditor) {Push-Location $psEditor.Workspace.Path}
else {ModernConveniences\Stop-ThrowError 'Missing psEditor object' -NotImplemented}
