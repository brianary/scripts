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
ConvertFrom-Base64.ps1 dXNlcm5hbWU6QmFkUEBzc3dvcmQ= utf8

username:BadP@ssword
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
