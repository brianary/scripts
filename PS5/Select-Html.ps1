<#
.SYNOPSIS
Returns content from the HTML retrieved from a URL.

.LINK
Invoke-WebRequest

.EXAMPLE
Select-Html.ps1 https://www.h2g2.com/ title

h2g2 - The Guide to Life, The Universe and Everything

.EXAMPLE
Select-Html.ps1 https://www.githubstatus.com/ .page-status -IgnoreAttributes

All Systems Operational

.EXAMPLE
Select-Html.ps1 https://www.irs.gov/e-file-providers/foreign-country-code-listing-for-modernized-e-file

CountryName CountryCode
----------- -----------
Afghanistan AF
Akrotiri    AX
Albania     AL
...

.EXAMPLE
Select-Html.ps1 https://www.federalreserve.gov/aboutthefed/k8.htm |Format-Table -AutoSize

_0                                   2021         2022          2023         2024        2025
--------                             ----         ----          ----         ----        ----
New Year's Day                       January 1    January 1*    January 1**  January 1   January 1
Birthday of Martin Luther King, Jr.  January 18   January 17    January 16   January 15  January 20
Washington's Birthday                February 15  February 21   February 20  February 19 February 17
Memorial Day                         May 31       May 30        May 29       May 27      May 26
Juneteenth National Independence Day June 19*     June 19**     June 19      June 19     June 19
Independence Day                     July 4**     July 4        July 4       July 4      July 4
Labor Day                            September 6  September 5   September 4  September 2 September 1
Columbus Day                         October 11   October 10    October 9    October 14  October 13
Veterans Day                         November 11  November 11   November 11* November 11 November 11
Thanksgiving Day                     November 25  November 24   November 23  November 28 November 27
Christmas Day                        December 25* December 25** December 25  December 25 December 25

.EXAMPLE
Select-Html.ps1 https://docs.microsoft.com/en-us/dotnet/core/compatibility/6.0 table -Contains AddProvider

Title                                                      Binarycompatible Sourcecompatible Introduced
-----                                                      ---------------- ---------------- ----------
AddProvider checks for non-null provider                   ✔️               ❌                RC 1
FileConfigurationProvider.Load throws InvalidDataException ✔️               ❌                RC 1
Resolving disposed ServiceProvider throws exception        ✔️               ❌                RC 1
#>

#Requires -Version 7
[CmdletBinding(DefaultParameterSetName='__AllParameterSets')] Param(
# The URL to read the HTML from.
[Parameter(Position=0,Mandatory=$true)][uri] $Uri,
<#
The name of elements to return all occurrences of,
or a dot followed by the class of elements to return all occurrences of,
or a hash followed by the ID of elements to return all occurrences of.
#>
[ValidatePattern('\A(?:\w+|[.#]\w+(?:-\w+)*)\z')]
[Parameter(Position=1)][Alias('Element','TagName','ClassName','ElementId')][string] $Select = 'table',
# Only elements whose inner text contain this value are included.
[Parameter(ParameterSetName='Contains')][string] $Contains,
# The position of an individual element to select, or all matching elements by default.
[Parameter(ParameterSetName='Index')]
[Alias('Position','Number')][int] $Index = -1,
<#
Includes <script> elements that can otherwise cause parsing issues,
usually these are removed first.
#>
[switch] $IncludeScript,
# Don't include an attribute hash in the output.
[switch] $IgnoreAttributes
)

function Get-AttributeValue($value) { return "$value".Trim() -replace '\s\s+',' ' }
function ConvertTo-Name($value) { return "$value".Trim() -replace '\W+','' }

$hash = @{}
[Collections.Generic.List[psobject]] $values = ,$hash

function Add-Text($e) {$values.Add($e.innerText)}

function Add-Input($e) {$hash.Add($e.id ?? $e.name, (Get-AttributeValue $e.value))}

function Add-Select($e)
{
	$hash.Add($e.id ?? $e.name, (Get-AttributeValue ($e.options[$e.selectedIndex].label ??
		$e.options[$e.selectedIndex].innerText)))
}

function Add-Meta($e)
{
	$hash.Add($e.name ?? $e.httpEquiv ?? $e.attributes['property'].nodeValue,
		(Get-AttributeValue $e.content))
}

function Add-Attributes($e)
{
	if($IgnoreAttributes) {return}
	foreach($att in $e.attributes |Where-Object specified -eq $true)
	{
		$hash.Add($att.nodeName, (Get-AttributeValue $att.nodeValue))
	}
}

function Add-List($e)
{
	$e.getElementsByTagName('li') |ForEach-Object {$values.Add($_.innerText)}
}

function Add-Table($e)
{
	$headers = New-Object string[] ($e.rows |ForEach-Object {$_.cells.length} |Measure-Object -Maximum).Maximum
	$rows = @()
	if($e.tHead -and $e.tHead.rows.length -gt 0)
	{
		$rows = $e.tHead.rows
		foreach($row in $rows)
		{
			foreach($c in 0..($row.cells.length-1))
			{
				$headers[$c] += ConvertTo-Name $row.cells[$c].innerText
			}
		}
		0..($headers.length-1) |Where-Object {!$headers[$_]} |ForEach-Object {$headers[$_] = "_$_"}
		$rows = $e.tBodies |ForEach-Object {$_.rows}
	}
	else
	{
		foreach($c in 0..($e.rows[0].cells.length-1))
		{
			$headers[$c] += ConvertTo-Name $row.cells[$c].innerText
		}
		$rows = $e.rows |Select-Object -Skip 1
	}
	foreach($row in $rows)
	{
		$value = [ordered]@{}
		0..($row.cells.length-1) |ForEach-Object {$value.Add($headers[$_], $row.cells[$_].innerText)}
		$values.Add([pscustomobject]$value)
	}
}

$dom = New-Object -ComObject HTMLFile
function Get-Elements
{
	if($Select -like '#*') {,$dom.getElementById($Select.Trim('#'))}
	else
	{
		$found = $Select -like '.*' ? $dom.getElementsByClassName($Select.Trim('.')) :  $dom.getElementsByTagName($Select)
		switch($PSCmdlet.ParameterSetName)
		{
			Index {if($Index -gt -1) {,$found[$Index]}}
			Contains {for($i = 0; $i -lt $found.length; $i++) {if($found[$i].innerText.Contains($Contains)) {$found[$i]}}}
			default {for($i = 0; $i -lt $found.length; $i++) {$found[$i]}}
		}
	}
}

function Add-Element($e)
{
	if(!$e) {return}
	switch($e.nodeName)
	{
		table    {Add-Table $e}
		ol       {Add-List $e}
		ul       {Add-List $e}
		menu     {Add-List $e}
		meta     {Add-Meta $e}
		input    {Add-Input $e}
		button   {Add-Input $e}
		textarea {Add-Input $e}
		select   {Add-Select $e}
		form     {$e.elements |ForEach-Object {Add-Element $_}}
		default
		{
			Add-Attributes $e
			if($e.innerText) {Add-Text $e}
		}
	}
}

function Get-Html
{
	$html =
		if(Test-Path $Uri.OriginalString -Type Leaf) {Get-Content $Uri.OriginalString -Raw}
		elseif($Uri.IsFile -or $Uri.IsUnc) {Get-Content $Uri.LocalPath -Raw}
		else {Invoke-RestMethod $Uri |Out-String}
	if(!$IncludeScript) {$html = $html -replace '<script.*?</script>',''}
	$dom.write(([Text.Encoding]::Unicode.GetBytes($html)))
	Get-Elements |ForEach-Object {Write-Debug "$($_ -eq $null ? '(null)' : $_.outerHTML)"; Add-Element $_}
	return $values
}

Get-Html
