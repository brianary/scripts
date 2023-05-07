<#
.SYNOPSIS
Returns whether the file is binary or text, and what encoding, line endings, and indents text files contain.

.NOTES
TODO: indent size, trailing whitespace, max line length, 2σ (95% max line length)

.INPUTS
Any object with a Path or FullName property to use for a file location.

.OUTPUTS
System.Management.Automation.PSObject with the following properties:

* Path the full path of the file.
* IsBinary indicates a binary (vs text) file.
* Encoding contains the encoding of a text file.
* LineEndings indicates the type of line endings used in a text file.
* Indents indicates the type of indent characters used in a text file.

.EXAMPLE
Get-FileContentsInfo.ps1 Get-FileContentsInfo.ps1

Path          : A:\scripts\Get-FileContentsInfo.ps1
IsBinary      : False
Encoding      : System.Text.ASCIIEncoding+ASCIIEncodingSealed
Utf8Signature : False
LineEndings   : CRLF
Indents       : Tabs
FinalNewline  : True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([pscustomobject])] Param(
# The location of a file.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[Alias('FullName')][string] $Path
)
Process
{
	foreach($file in (Resolve-Path $Path).Path)
	{
		if(Test-FileTypeMagicNumber.ps1 text $file)
		{
			[pscustomobject]@{
				Path          = Resolve-Path $file
				IsBinary      = $false
				Encoding      = Get-FileEncoding.ps1 $file
				Utf8Signature = Test-Utf8Signature.ps1 $file
				LineEndings   = Get-FileLineEndings.ps1 $file
				Indents       = Get-FileIndentCharacter.ps1 $file
				FinalNewline  = Test-FinalNewline.ps1 $file
			}
		}
		else
		{
			[pscustomobject]@{
				Path          = Resolve-Path $file
				IsBinary      = $true
				Encoding      = $null
				Utf8Signature = $null
				LineEndings   = $null
				Indents       = $null
				FinalNewline  = $null
			}
		}
	}
}
