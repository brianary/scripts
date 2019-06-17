<#
.Synopsis
    Pushes the current VS Code editor workspace location to the location stack.
#>

#Requires -Version 3
[CmdletBinding()] Param()
if(Get-Variable psEditor -ValueOnly -EA 0) {Push-Location $psEditor.Workspace.Path}
else {Stop-ThrowError.ps1 NotSupportedException 'Missing psEditor object' ObjectNotFound 0 psEditor}
