<#
.SYNOPSIS
Converts bytes or text to base64-encoded text.

.INPUTS
System.String or System.Byte[] of data to base64-encode.

.OUTPUTS
System.String containing the base64-encoded data.

.FUNCTIONALITY
Base64

.LINK
https://docs.microsoft.com/dotnet/api/system.convert.tobase64string

.EXAMPLE
ConvertTo-Base64.ps1 'username:BadP@ssword' utf8

dXNlcm5hbWU6QmFkUEBzc3dvcmQ=
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# Binary data to convert.
[Parameter(ParameterSetName='BinaryData',Position=0,Mandatory=$true)][byte[]] $Data,
# Text data to convert.
[Parameter(ParameterSetName='TextData',Position=0,Mandatory=$true)][string] $Text,
# The text encoding to use when converting text to binary data.
[Parameter(ParameterSetName='TextData',Position=1)]
[ValidateSet('ascii','utf16','utf16BE','utf32','utf32BE','utf7','utf8')]
[string] $Encoding = 'utf8',
<#
Indicates that the URI-friendly variant of the base64 algorithm should be used.
This variant, as used by JWTs, uses - instead of +, and _ instead of /, and trims the = padding at the end
to avoid extra escaping within URLs or URL-encoded data.
#>
[switch] $UriStyle
)

if($Text)
{
	$encoder = [Text.Encoding]::GetEncoding(($Encoding -replace '^utf','utf-'))
	$Data = $encoder.GetBytes($Text)
}
$value= [Convert]::ToBase64String($Data)
if($UriStyle) {$value.Trim('=') -replace '\+','-' -replace '/','_'}
else {$value}
