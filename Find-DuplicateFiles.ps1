<#
.SYNOPSIS
Removes duplicates from a list of files.

.INPUTS
System.IO.FileInfo list, typically piped from Get-ChildItem.

.OUTPUTS
System.String containing the full paths of the both matching files.

.FUNCTIONALITY
Files

.EXAMPLE
Get-ChildItem -Recurse -File |Find-DuplicateFiles.ps1 |Remove-Item

Removes all but the oldest file with the same size and hash value.
#>

#Requires -Version 5
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseProcessBlockForPipelineCommand','',
Justification='This script uses input within an End block.')]
[CmdletBinding()][OutputType([string])] Param(
# A list of files to search for duplicates.
[Parameter(ValueFromPipeline=$true,ValueFromRemainingArguments=$true)][IO.FileInfo[]]$Files
)
Begin
{
    if(!(Get-Command Get-FileHash -Module Microsoft.PowerShell.Utility -ErrorAction Ignore))
    {throw 'Get-FileHash not found.'}
    $total,$totalsize = 0,0
}
End
{
    foreach($size in ($Files |Group-Object Length |Where-Object Count -gt 1))
    {
        foreach($hash in ($size.Group |Group-Object @{e={(Get-FileHash $_.FullName).Hash}} |Where-Object Count -gt 1))
        {
            $first = $hash.Group |Sort-Object LastWriteTime |Select-Object -First 1
            foreach($dup in ($hash.Group |Sort-Object LastWriteTime |Select-Object -Skip 1))
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

