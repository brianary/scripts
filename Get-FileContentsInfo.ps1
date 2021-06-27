<#
.Synopsis
	Returns whether the file is binary or text, and what encoding, line endings, and indents text files contain.

.Parameter Path
	The location of a file.

.Inputs
	Any object with a Path or FullName property to use for a file location.

.Outputs
	System.Management.Automation.PSObject with the following properties:

	* Path the full path of the file.
	* IsBinary indicates a binary (vs text) file.
	* Encoding contains the encoding of a text file.
	* LineEndings indicates the type of line endings used in a text file.
	* Indents indicates the type of indent characters used in a text file.

.Example
	Get-FileContentsInfo.ps1 Get-FileContentsInfo.ps1

	Path        : A:\Scripts\Get-FileContentsInfo.ps1
	IsBinary    : False
	Encoding    : System.Text.ASCIIEncoding+ASCIIEncodingSealed
	LineEndings : CRLF
	Indents     : Tabs
#>

#Requires -Version 3
[CmdletBinding()][OutputType([pscustomobject])] Param(
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
				Path        = Resolve-Path $file
				IsBinary    = $false
				Encoding    = Get-FileEncoding.ps1 $file
				LineEndings = Get-FileLineEndings.ps1 $file
				Indents     = Get-FileIndentCharacter.ps1 $file
			}
		}
		else
		{
			[pscustomobject]@{
				Path        = Resolve-Path $file
				IsBinary    = $true
				Encoding    = $null
				LineEndings = $null
				Indents     = $null
			}
		}
	}
}
