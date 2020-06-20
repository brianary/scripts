<#
.Synopsis
    Removes duplicates from a list of files.

.Parameter Files
    A list of files to search for duplicates.

.Inputs
	System.IO.FileInfo list, typically piped from Get-ChildItem.

.Outputs
	System.String containing the full paths of the both matching files.

.Example
    Get-ChildItem -Recurse -File |Find-DuplicateFiles.ps1 |Remove-Item

    Removes all but the oldest file with the same size and hash value.
#>

#Requires -Version 5
[CmdletBinding()][OutputType([string])] Param(
[Parameter(ValueFromPipeline=$true,ValueFromRemainingArguments=$true)][IO.FileInfo[]]$Files
)
Begin
{
    if(!(Get-Command Get-FileHash -CommandType Function -Module Microsoft.PowerShell.Utility))
    {throw "Get-FileHash not found."}
    $total,$totalsize = 0,0
    [IO.FileInfo[]]$filesAccumulated = @()
}
Process
{
    $filesAccumulated += @($Files)
}
End
{
    foreach($size in ($filesAccumulated |group Length |? Count -gt 1))
    {
        foreach($hash in ($size.Group |group @{e={(Get-FileHash $_.FullName).Hash}} |? Count -gt 1))
        {
            $first = $hash.Group |sort LastWriteTime |select -First 1
            foreach($dup in ($hash.Group |sort LastWriteTime |select -Skip 1))
            {
                Write-Verbose "$($dup.FullName) (duplicates $($first.FullName))"
                Write-Output $dup.FullName
                $total++
                $totalsize += $dup.Length
            }
        }
    }
    if($total) {Write-Verbose "Found $total duplicate files ($totalsize bytes)"}
}
