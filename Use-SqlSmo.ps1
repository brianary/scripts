<#
.Synopsis
    Find and load installed SQL SMO types.

.Example
    Use-SqlSmo.ps1 ; $SmoServer = New-Object Microsoft.SqlServer.Management.Smo.Server('(localdb)\instance')

    Ensures SQL SMO objects are loaded before use.
#>

#Requires -Version 3
[CmdletBinding()] Param()

# load SMO
try
{
    [void][Microsoft.SqlServer.Management.Smo.Server]
    [void][Microsoft.SqlServer.Management.Smo.ScriptingOptions]
    Write-Verbose "Types already loaded."
}
catch
{
    $sqlsdk = Get-ChildItem "$env:ProgramFiles\Microsoft SQL Server\Microsoft.SqlServer.Smo.dll" -Recurse |
        Find-NewestFile.ps1 -Verbose |
        Split-Path
    Write-Verbose "Found SQL SDK DLLs in $sqlsdk"
    Add-Type -Path "$sqlsdk\Microsoft.SqlServer.Smo.dll"
    Add-Type -Path "$sqlsdk\Microsoft.SqlServer.SqlEnum.dll"
}
