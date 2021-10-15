<#
.Synopsis
	Adds the utf-8 signature (BOM) to a file.

.Parameter Path
	The file to add the utf-8 signature to.

.Inputs
	System.String containing the path to the file to be updated.

.Link
	https://msdn.microsoft.com/library/s064f8w2aspx

.Link
	https://msdn.microsoft.com/library/ms143376aspx

.Link
	Get-Content

.Example
	Add-Utf8Signature.ps1 README.md

	Adds the EF BB BF at the beginning of the file, warns if it isn't found.
#>

#Requires -Version 4
[CmdletBinding()][OutputType([void])] Param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string]$Path
)
Process
{
	Write-Verbose "Adding utf-8 BOM/SIG from $Path"
	if(Test-FileTypeMagicNumber.ps1 utf8 $Path){Write-Warning "A utf-8 signature was already found in $Path"; return}
	# this will have to do until PS6 http://brianary.github.io/powershell-encoding.html
	[IO.File]::WriteAllText((Resolve-Path $Path),(Get-Content $Path -Raw),(New-Object System.Text.UTF8Encoding $true))
}
