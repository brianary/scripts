<#
.Synopsis
	Returns content from the HTML retrieved from a URL.

.Parameter Uri
	The URL to read the HTML from.

.Parameter TagName
	The name of elements to return all occurrences of.

.Parameter ClassName
	The class of elements to return all occurrences of.

.Parameter ElementId
	The ID of elements to return all occurrences of.

.Parameter Index
	The position of an individual element to select, or all matching elements by default.

.Parameter IgnoreScript
	Removes <script> elements that can cause parsing issues.

.Link
	Invoke-WebRequest

.Example
	Select-Html.ps1 https://www.h2g2.com/ title

	h2g2 - The Guide to Life, The Universe and Everything

.Example
	Select-Html.ps1 https://www.irs.gov/e-file-providers/foreign-country-code-listing-for-modernized-e-file

	CountryName CountryCode
	----------- -----------
	Afghanistan AF
	Akrotiri    AX
	Albania     AL
	...

.Example
	Select-Html.ps1 https://www.federalreserve.gov/aboutthefed/k8.htm -IgnoreScript |Format-Table -AutoSize

	Column_0                             2021         2022          2023         2024        2025
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
#>

#Requires -Version 7
[CmdletBinding(DefaultParameterSetName='TagName')] Param(
[Parameter(Position=0,Mandatory=$true)][uri] $Uri,
[Parameter(ParameterSetName='TagName',Position=1)]
[ValidatePattern('\A\w+\z')][string] $TagName = 'table',
[Parameter(ParameterSetName='ClassName',Mandatory=$true)][string] $ClassName,
[Parameter(ParameterSetName='ElementId',Mandatory=$true)][string] $ElementId,
[Parameter(ParameterSetName='TagName',Position=2)]
[Parameter(ParameterSetName='ClassName',Position=2)]
[Alias('Position','Number')][int] $Index = -1,
[switch] $IgnoreScript
)

function Get-AttributeValue($value) { return "$value".Trim() -replace '\s\s+',' ' }
function ConvertTo-Name($value) { return "$value".Trim() -replace '\W+','' }

$hash = @{}
[Collections.Generic.List[psobject]] $values = $hash

function Add-Text($e) {$values.Add($e.innerText)}

function Add-Input($e) {$hash.Add($e.name, (Get-AttributeValue $e.value))}

function Add-Select($e)
{
	$hash.Add($e.name, (Get-AttributeValue ($e.options[$e.selectedIndex].label ??
		$e.options[$e.selectedIndex].innerText)))
}

function Add-Meta($e)
{
	$hash.Add($e.name ?? $e.httpEquiv ?? $e.attributes['property'].nodeValue,
		(Get-AttributeValue $e.content))
}

function Add-Attributes($e)
{
	foreach($att in $e.attributes |where specified -eq $true)
	{
		$hash.Add($att.nodeName, (Get-AttributeValue $att.nodeValue))
	}
}

function Add-Table($e)
{
	$headers = New-Object string[] ($e.rows |foreach {$_.cells.length} |measure -Maximum).Maximum
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
		0..($headers.length-1) |
			where {[string]::IsNullOrWhiteSpace($headers[$_])} |
			foreach {$headers[$_] = 'Column_{0}' -f $_}
		$rows = $e.tBodies |foreach {$_.rows}
	}
	else
	{
		foreach($c in 0..($e.rows[0].cells.length-1))
		{
			$headers[$c] += ConvertTo-Name $row.cells[$c].innerText
		}
		$rows = $e.rows |select -Skip 1
	}
	foreach($row in $rows)
	{
		$value = [ordered]@{}
		0..($row.cells.length-1) |foreach {$value.Add($headers[$_], $row.cells[$_].innerText)}
		$values.Add([pscustomobject]$value)
	}
}

$dom = New-Object -ComObject HTMLFile
function Get-Elements
{
	switch($PSCmdlet.ParameterSetName)
	{
		ElementId {@($dom.getElementById($ElementId))}
		ClassName
		{
			if($Index -gt -1) {@($dom.getElementsByClassName($TagName)[$Index])}
			else
			{
				$found = $dom.getElementsByClassName($TagName)
				for($i = 0; $i -lt $found.length; $i++) {$found[$i]}
			}
		}
		TagName
		{
			if($Index -gt -1) {@($dom.getElementsByTagName($TagName)[$Index])}
			else
			{
				$found = $dom.getElementsByTagName($TagName)
				for($i = 0; $i -lt $found.length; $i++) {$found[$i]}
			}
		}
	}
}

function Get-Html
{
	$html =
		if(Test-Path $Uri.OriginalString -Type Leaf) {Get-Content $Uri.OriginalString -Raw}
		elseif($Uri.IsFile -or $Uri.IsUnc) {Get-Content $Uri.LocalPath -Raw}
		else {Invoke-RestMethod $Uri |Out-String}
	if($IgnoreScript) {$html = $html -replace '<script.*?</script>',''}
	$dom.write(([Text.Encoding]::Unicode.GetBytes($html)))
	foreach($e in Get-Elements)
	{
		Write-Debug $e.outerHTML
		switch($e.nodeName)
		{
			table {Add-Table $e}
			meta {Add-Meta $e}
			input {Add-Input $e}
			button {Add-Input $e}
			textarea {Add-Input $e}
			select {Add-Select $e}
			default
			{
				Add-Attributes $e
				if($e.innerText) {Add-Text $e}
			}
		}
	}
	return $values
}

Get-Html
