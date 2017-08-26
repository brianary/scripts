<#
.Synopsis
    Removes a file that may be prone to locking.

.Inputs
    System.String containing the path of a file to delete (or rename if deleting fails).

.Parameter Path
    Specifies a path to the items being removed. Wildcards are permitted.
    The parameter name ("-Path") is optional.

.Example
    Remove-LockyFile.ps1 InUse.dll

    (Tries to remove file, renames it if unable to.)
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[string]$Path
)
Process
{
    try { Remove-Item $Path -Force }
    catch
    {
        $NewPath = "$Path~$([guid]::NewGuid().Guid)"
        Move-Item $Path $NewPath
        try { Remove-Item $NewPath -Force }
        catch { Write-Warning "Renamed file, but unable to remove $(Resolve-Path $NewPath)" }
    }
}
