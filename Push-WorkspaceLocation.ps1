<#
.Synopsis
    Pushes the current VS Code editor workspace location to the location stack.

.Link
	Test-Variable.ps1

.Link
	Stop-ThrowError.ps1

.Link
	Push-Location

.Example
	Push-WorkspaceLocation.ps1

	Pushes the current directory onto the stack, and changes to the workspace directory.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param()
if(Test-Variable.ps1 psEditor) {Push-Location $psEditor.Workspace.Path}
else {Stop-ThrowError.ps1 'Missing psEditor object' -NotImplemented}
