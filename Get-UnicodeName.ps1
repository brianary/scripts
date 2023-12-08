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
[Parameter(ParameterSetName='Character',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Character,
# Update the character name database.
[Parameter(ParameterSetName='Update')][switch] $Update
)
Begin
{
	$basename = Join-Path -Path $PSScriptRoot -ChildPath data -AdditionalChildPath UnicodeName
	$cc = ConvertFrom-StringData (Get-Content "$basename.cc.txt" -Raw)
	$name = ConvertFrom-StringData (Get-Content "$basename.txt" -Raw)
}
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Update
		{
			Get-UnicodeData.ps1 |
				Select-Object Value,@{n='Name';e={
					$hex = '{0:X4}' -f $_.Value
					$cc.ContainsKey($hex) ? $cc[$hex] : $_.Name
				}} |
				Export-Csv "$basename.txt" -Delimiter '='
			Write-Information 'Updated.'
			return
		}
		Character
		{
			return $Character.GetEnumerator() |ForEach-Object {[int]$_} |Get-UnicodeName.ps1
		}
		default
		{
			$hex = '{0:X4}' -f $CodePoint
			return $cc.ContainsKey($hex) ? $cc[$hex] : $name[$hex]
		}
	}
}
