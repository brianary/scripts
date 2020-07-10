<#
.Synopsis
	Convert a number to a Roman numeral.

.Parameter Value
	The numeric value to convert into a Roman numeral string.

.Parameter Unicode
	Indicates that Unicode Roman numeral characters should be used (U+2160-U+216F).

.Inputs
	System.Int32 value to convert to a Roman numeral string.

.Outputs
	System.String containing a Roman numeral.

.Link
	https://www.c-sharpcorner.com/blogs/converting-to-and-from-roman-numerals1

.Link
	Get-Variable

.Example
	ConvertTo-RomanNumeral.ps1 2020

	MMXX

.Example
	ConvertTo-RomanNumeral.ps1 8

	VIII
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][ValidateRange(1,3999)][int] $Value,
[switch] $Unicode
)
Begin
{
	${1000} = if($Unicode) {@('ⅯⅯⅯ','ⅯⅯ','Ⅿ')} else {@('MMM','MM','M')}
	${100} = if($Unicode) {@('ⅭⅯ','ⅮⅭⅭⅭ','ⅮⅭⅭ','ⅮⅭ','Ⅾ','ⅭⅮ','ⅭⅭⅭ','ⅭⅭ','Ⅽ')} else {@('CM','DCCC','DCC','DC','D','CD','CCC','CC','C')}
	${10} = if($Unicode) {@('ⅩⅭ','ⅬⅩⅩⅩ','ⅬⅩⅩ','ⅬⅩ','Ⅼ','ⅩⅬ','ⅩⅩⅩ','ⅩⅩ','Ⅹ')} else {@('XC','LXXX','LXX','LX','L','XL','XXX','XX','X')}
	${1} = if($Unicode) {@('Ⅸ','Ⅷ','Ⅶ','Ⅵ','Ⅴ','Ⅳ','Ⅲ','Ⅱ','Ⅰ')} else {@('IX','VIII','VII','VI','V','IV','III','II','I')}
	function Split-Magnitude([int]$x,[int]$magnitude,[string]$acc='')
	{
		$m = Get-Variable $magnitude -ValueOnly
		return ($acc+$m[$m.Length - [math]::Floor($x/$magnitude)]),($x % $magnitude)
	}
}
Process
{
	$rn,$rem = Split-Magnitude $Value 1000
	$rn,$rem = Split-Magnitude $rem 100 $rn
	$rn,$rem = Split-Magnitude $rem 10 $rn
	$rn,$rem = Split-Magnitude $rem 1 $rn
	$rn = $rn -replace 'ⅩⅡ\z','Ⅻ' -replace 'ⅩⅠ\z','Ⅺ'
	return $rn
}
