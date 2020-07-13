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
	${1000} = if($Unicode) {@('Ⅿ','ⅯⅯ','ⅯⅯⅯ')} else {@('M','MM','MMM')}
	${100} = if($Unicode) {@('Ⅽ','ⅭⅭ','ⅭⅭⅭ','ⅭⅮ','Ⅾ','ⅮⅭ','ⅮⅭⅭ','ⅮⅭⅭⅭ','ⅭⅯ')} else {@('C','CC','CCC','CD','D','DC','DCC','DCCC','CM')}
	${10} = if($Unicode) {@('Ⅹ','ⅩⅩ','ⅩⅩⅩ','ⅩⅬ','Ⅼ','ⅬⅩ','ⅬⅩⅩ','ⅬⅩⅩⅩ','ⅩⅭ')} else {@('X','XX','XXX','XL','L','LX','LXX','LXXX','XC')}
	${1} = if($Unicode) {@('Ⅰ','Ⅱ','Ⅲ','Ⅳ','Ⅴ','Ⅵ','Ⅶ','Ⅷ','Ⅸ')} else {@('I','II','III','IV','V','VI','VII','VIII','IX')}
	function Split-Magnitude([int]$x,[int]$magnitude,[string]$acc='')
	{
		Write-Verbose "x: $x  mag: $magnitude  acc: $acc"
		$m = Get-Variable $magnitude -ValueOnly
		$i = [math]::Floor($x/$magnitude) -1
		if($i -lt 0 -or $i -ge $m.Length) {return $acc,$x}
		else {return ($acc+$m[$i]),($x % $magnitude)}
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
