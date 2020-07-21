<#
.Synopsis
	Determines whether a file can be parsed as UTF-8 successfully.

.Parameter Path

.Inputs
	System.IO.FileInfo file to test for UTF-8 validity.

.Outputs
	System.Boolean indicating whether the file parses sucessfully.

.Link
	https://docs.microsoft.com/en-us/dotnet/api/system.text.utf8encoding.-ctor?view=netframework-4.8

.Example
	Test-Utf8Encoding.ps1 file.txt

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
