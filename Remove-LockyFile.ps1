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

    (Tries to remove file, renames it if unable to, tries deleting at reboot as a last resort.)
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[string]$Path
)
Process
{
    try{[void][RebootFileAction]}catch{Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class RebootFileAction
{
    [DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Auto)]
    private static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, int dwFlags);
    const int MOVEFILE_DELAY_UNTIL_REBOOT = 0x4;
    static public void Delete(string filename)
    {
        if(!MoveFileEx(filename,"",MOVEFILE_DELAY_UNTIL_REBOOT))
        { throw new InvalidOperationException(String.Format("Unable to mark {0} for deletion at reboot.",filename)); }
    }
}
'@}
    try { Remove-Item $Path -Force -ErrorAction Stop }
    catch
    {
        $NewPath = "$Path~$([guid]::NewGuid().Guid)"
        try
        {
            Move-Item $Path $NewPath -Force -ErrorAction Stop
            $Path = Resolve-Path $NewPath
            try { Remove-Item $Path -Force -ErrorAction Stop }
            catch { Write-Warning "Renamed file, but unable to remove $Path"; throw }
        }
        catch
        {
            [RebootFileAction]::Delete((Resolve-Path $Path))
            Write-Warning "File $Path has been marked for deletion at reboot."
        }
    }
}
