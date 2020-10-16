<#
.Synopsis
    Pushes the current VS Code editor workspace location to the location stack.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param()
if(Test-Variable.ps1 psEditor) {Push-Location $psEditor.Workspace.Path}
else {Stop-ThrowError.ps1 'Missing psEditor object' -NotImplemented}
