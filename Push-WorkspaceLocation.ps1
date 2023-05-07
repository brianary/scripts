<#
.SYNOPSIS
Pushes the current VS Code editor workspace location to the location stack.

.FUNCTIONALITY
VSCode

.LINK
Test-Variable.ps1

.LINK
Stop-ThrowError.ps1

.LINK
Push-Location

.EXAMPLE
Push-WorkspaceLocation.ps1

Pushes the current directory onto the stack, and changes to the workspace directory.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param()
if(Test-Variable.ps1 psEditor) {Push-Location $psEditor.Workspace.Path}
else {Stop-ThrowError.ps1 'Missing psEditor object' -NotImplemented}
