<#
.SYNOPSIS
Converts base64-encoded text to bytes or text.

.INPUTS
System.String of base64-encoded text to decode.

.OUTPUTS
System.String or System.Byte[] of decoded text or data.

.FUNCTIONALITY
Data encoding

.LINK
https://docs.microsoft.com/dotnet/api/system.convert.frombase64string

.EXAMPLE
ConvertFrom-Base64.ps1 dXNlcm5hbWU6QmFkUEBzc3dvcmQ= -Encoding utf8

username:BadP@ssword

.EXAMPLE
'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9' |ConvertFrom-Base64.ps1 -Encoding ascii -UriStyle

{"alg":"HS256","typ":"JWT"}

.EXAMPLE
'77u/dHJ1ZQ0K' |ConvertFrom-Base64.ps1 |Format-Hex

   Label: Byte (System.Byte) <3D01E7E8>

          Offset Bytes                                           Ascii
                 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
          ------ ----------------------------------------------- -----
0000000000000000 EF BB BF 74 72 75 65 0D 0A                      ï»¿true��
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string],[byte[]])] Param(
# The base64-encoded data.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Data,
<#
Uses the specified encoding to convert the bytes in the data to text.

If no encoding is provided, the data will be returned as a byte array.
#>
[Parameter(Position=1)][ValidateSet('ascii','byte','utf16','utf16BE','utf32','utf32BE','utf7','utf8')]
[string] $Encoding = 'byte',
<#
Indicates that the URI-friendly variant of the base64 algorithm should be used.
This variant, as used by JWTs, uses - instead of +, and _ instead of /, and trims the = padding at the end
to avoid extra escaping within URLs or URL-encoded data.
#>
[switch] $UriStyle
)
Process
{
	if($UriStyle)
	{
		$Data = $Data -replace '-','+' -replace '_','/'
		$Data += New-Object string '=',(3-(($Data.Length-1)% 4))
	}
	$value = [Convert]::FromBase64String($Data)
	if($Encoding -eq 'byte') {$value}
	else
	{
		$encoder = [Text.Encoding]::GetEncoding(($Encoding -replace '^utf','utf-'))
		$encoder.GetString($value)
	}
}
