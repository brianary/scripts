<#
.SYNOPSIS
Tests a file for a "magic number" (identifying sequence of bytes) at a given location.

.INPUTS
System.String path of a file to read.

.OUTPUTS
System.Boolean affirming that the bytes provided were found at the position given in the specified file.

.FUNCTIONALITY
Data formats

.LINK
https://en.wikipedia.org/wiki/Magic_number_(programming)

.LINK
Get-Content

.EXAMPLE
Test-MagicNumber.ps1 0xEF,0xBB,0xBF README.md

True if a utf-8 signature (or "BOM", byte-order-mark) is found.

.EXAMPLE
Test-MagicNumber.ps1 0x0D,0x0A README.md -Offset -2

True if README.md ends with a Windows line-ending.

.EXAMPLE
Test-MagicNumber.ps1 0x50,0x4B download123543

True if download123543 starts with a PK ZIP magic number ("PK"), and is therefore likely ZIP data.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
# A list of byte values to compare against those read from the file.
[Parameter(Position=0,Mandatory=$true)][byte[]]$Bytes,
# A file to look for the bytes in.
[Parameter(Position=2,ValueFromPipelineByPropertyName=$true)]
[ValidateScript({Test-Path $_ -Type Leaf})][Alias('FullName')][string]$Path,
<#
The number bytes into the file to begin reading the bytes to compare.
Use a negative number to count from the end of the file.
#>
[int] $Offset = 0
)
Begin
{
	$readbytes =
		if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
		else {@{Encoding='Byte'}}
	Write-Verbose "Testing for magic number $(($Bytes |ForEach-Object {$_.ToString("X")}) -join ' ') at $Offset"
	$GetBytes =
		if(!$Offset)
		{{param($f); Get-Content $f @readbytes -TotalCount $Bytes.Count}.GetNewClosure()}
		elseif($Offset -gt 0)
		{{param($f); Get-Content $f @readbytes -TotalCount ($Offset + $Bytes.Count) |Select-Object -Skip $Offset}.GetNewClosure()}
		else
		{{param($f); Get-Content $f @readbytes -Tail (-$Offset)}.GetNewClosure()}
}
Process
{
	Write-Verbose "Testing for magic number in $Path"
	[byte[]]$data = &$GetBytes $Path
	if(!$data -or !$data.Length) {return $false}
	for($i = 0; $i -lt $Bytes.Count; $i++){if($data[$i] -ne $Bytes[$i]){return $false}}
	return $true
}

