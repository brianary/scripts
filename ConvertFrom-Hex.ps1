<#
.Synopsis
	Convert a string of hexadecimal digits into a byte array.

.Parameter InputObject
	A string of hex digits.

.Inputs
	System.String of hex digits.

.Outputs
	System.Byte[] of bytes parsed from hex digits.

.Link
	https://docs.microsoft.com/dotnet/api/system.numerics.biginteger.parse#System_Numerics_BigInteger_Parse_System_String_System_Globalization_NumberStyles_

.Link
	https://docs.microsoft.com/dotnet/api/system.array.reverse#System_Array_Reverse_System_Array_

.Example
	ConvertFrom-Hex.ps1 'EF BB BF'

	239
	187
	191

.Example
	[text.encoding]::UTF8.GetString((ConvertFrom-Hex.ps1 0x25504446))

	%PDF

.Example
	'{0:X2} {1:X2} {2:X2}' -f (ConvertFrom-Hex.ps1 c0ffee)

	C0 FF EE
#>

#Requires -Version 3
[CmdletBinding()][OutputType([byte[]])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $InputObject
)
Process
{
	$hex = $InputObject -replace '\A0x|[^0-9A-Fa-f]+',''
	[byte[]] $value = [bigint]::Parse("00$hex",'HexNumber').ToByteArray()
	[array]::Reverse($value)
	while($value.Length -gt ($hex.Length / 2)) {$null,$value = $value}
	return $value
}
