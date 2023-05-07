<#
.SYNOPSIS
Returns the encoding for a given file, suitable for passing to encoding parameters.

.LINK
Test-FileTypeMagicNumber.ps1

.EXAMPLE
Get-FileEncoding.ps1 README.md

IsSingleByte      : True
Preamble          :
BodyName          : us-ascii
EncodingName      : US-ASCII
HeaderName        : us-ascii
WebName           : us-ascii
WindowsCodePage   : 1252
IsBrowserDisplay  : False
IsBrowserSave     : False
IsMailNewsDisplay : True
IsMailNewsSave    : True
EncoderFallback   : System.Text.EncoderReplacementFallback
DecoderFallback   : System.Text.DecoderReplacementFallback
IsReadOnly        : True
CodePage          : 20127
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Text.Encoding])] Param(
# The path to a file.
[Parameter(Position=0,Mandatory=$true)][Alias('FullName')][string] $Path
)
Process
{
	if($PSVersionTable.PSEdition -eq 'Core')
	{
		if(Test-FileTypeMagicNumber.ps1 utf8 $Path) {[Text.Encoding]::UTF8}
		elseif(Test-FileTypeMagicNumber.ps1 utf16 $Path) {[Text.Encoding]::Unicode}
		elseif(Test-FileTypeMagicNumber.ps1 utf16be $Path) {[Text.Encoding]::BigEndianUnicode}
		elseif(Test-FileTypeMagicNumber.ps1 utf32 $Path) {[Text.Encoding]::UTF32}
		elseif(Test-FileTypeMagicNumber.ps1 utf32be $Path) {[Text.Encoding]::GetEncoding('UTF-32BE')}
		elseif(Test-FileTypeMagicNumber.ps1 text $Path) {[Text.Encoding]::ASCII}
		else {[Text.Encoding]::Default}
	}
	else
	{
		if(Test-FileTypeMagicNumber.ps1 utf8 $Path) {'utf8'}
		elseif(Test-FileTypeMagicNumber.ps1 utf16 $Path) {'unicode'}
		elseif(Test-FileTypeMagicNumber.ps1 utf16be $Path) {'bigendianunicode'}
		elseif(Test-FileTypeMagicNumber.ps1 utf32 $Path) {'utf32'}
		elseif(Test-FileTypeMagicNumber.ps1 utf32be $Path) {'utf32be'} # not supported
		elseif(Test-FileTypeMagicNumber.ps1 text $Path) {'ascii'}
		else {'default'}
	}
}
