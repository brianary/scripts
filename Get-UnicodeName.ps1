<#
.SYNOPSIS
Returns the name of a Unicode code point.

.INPUTS
System.Int32 of a Unicode code point value to name, or
System.String of Unicode characters to name.

.OUTPUTS
System.String of the Unicode code point name.

.FUNCTIONALITY
Unicode

.LINK
https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt

.EXAMPLE
Get-UnicodeName.ps1 32

SPACE
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# The numeric value of the Unicode character.
[Parameter(ParameterSetName='CodePoint',Position=0,Mandatory=$true,ValueFromPipeline=$true)][int] $CodePoint,
# The Unicode character.
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Character
)
Begin {$name = ConvertFrom-StringData (Get-Content ([io.path]::ChangeExtension($PSCommandPath,'txt')) -Raw)}
Process
{
	if($PSCmdlet.ParameterSetName -eq 'Character')
	{
		return $Character.GetEnumerator() |foreach {[int]$_} |Get-UnicodeName.ps1
	}
	else
	{
		return $name['{0:X4}' -f $CodePoint]
	}
}
