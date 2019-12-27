<#
.Synopsis
	Converts bytes or text to base-64-encoded text.

.Parameter Data
	Binary data to convert.

.Parameter Text
	Text data to convert.

.Parameter Encoding
	The text encoding to use when converting text to binary data.

.Parameter UriStyle
	Indicates that the URI-friendly variant of base-64 should be used.
	This variant, as used by JWTs, uses - instead of +, and _ instead of /, and trims the = padding at the end
	to avoid extra escaping within URLs or URL-encoded data.

.Outputs
	System.String containing the base-64-encoded data.

.Link
	https://docs.microsoft.com/dotnet/api/system.convert.tobase64string

.Example
	ConvertTo-Base64.ps1 'username:BadP@ssword' utf8

	dXNlcm5hbWU6QmFkUEBzc3dvcmQ=
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(ParameterSetName='BinaryData',Position=0,Mandatory=$true)][byte[]] $Data,
[Parameter(ParameterSetName='TextData',Position=0,Mandatory=$true)][string] $Text,
[Parameter(ParameterSetName='TextData',Position=1)]
[ValidateSet('ascii','utf16','utf16BE','utf32','utf32BE','utf7','utf8')]
[string] $Encoding = 'utf8',
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
