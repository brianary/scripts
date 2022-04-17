<#
.SYNOPSIS
Determines whether a file can be parsed as UTF-8 successfully.

.PARAMETER Path
The file to test.

.INPUTS
System.IO.FileInfo file or similar object to test for UTF-8 validity.

.OUTPUTS
System.Boolean indicating whether the file parses sucessfully.

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.text.utf8encoding.-ctor?view=netframework-4.8

.EXAMPLE
Test-Utf8Encoding.ps1 file.txt

True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path
)
Process
{
    $sr = New-Object IO.StreamReader $Path,(New-Object Text.UTF8Encoding $true,$true)
    try { $sr.ReadToEnd() |Out-Null; return $true }
    catch { Write-Verbose $_.Exception.Message; return $false }
}
