<#
.SYNOPSIS
Removes the utf-8 signature (BOM) from a file.

.INPUTS
System.String containing the path to the file to be updated.

.LINK
https://msdn.microsoft.com/library/dd383463.aspx

.LINK
https://msdn.microsoft.com/library/s064f8w2.aspx

.LINK
Get-Content

.EXAMPLE
Remove-Utf8Signature.ps1 README.md

Removes the EF BB BF at the beginning of the file, warns if it isn't found.
#>

#Requires -Version 4
[CmdletBinding()][OutputType([void])] Param(
# The file to remove the utf-8 signature from.
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string]$Path
)
Process
{
    Write-Verbose "Removing utf-8 BOM/SIG from $Path"
    if(!(Test-FileTypeMagicNumber.ps1 utf8 $Path)){Write-Warning "No utf-8 signature was found in $Path"; return}
    # this will have to do until PS6 http://brianary.github.io/powershell-encoding.html
    [IO.File]::WriteAllText((Resolve-Path $Path),(Get-Content $Path -Raw),(New-Object System.Text.UTF8Encoding $false))
}

