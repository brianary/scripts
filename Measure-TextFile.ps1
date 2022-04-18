<#
.SYNOPSIS
Counts each type of indent and line ending.

.INPUTS
System.String containing a filename to examine.

.OUTPUTS
System.Management.Automation.PSCustomObject containing these properties:

* Path: The original file path.
* Encoding: The name of the file encoding.
* Lines: The number of lines in the text file.
* LineEndings: CRLF, CR, and/or LF
* Indentation: Tabs, Spaces, or Mixed (with proportions).
* IndentSize: Number of spaces per indent (or 1 for Tabs).
* FinalNewline: A boolean indicating whether the file properly ends with an end-of-line.

.EXAMPLE
Measure-TextFile.ps1 .\Measure-TextFile.ps1

Path         : A:\scripts\Measure-TextFile.ps1
Encoding     : Unicode (UTF-8)
Lines        : 88
LineEndings  : CRLF
Indentation  : Tabs
IndentSize   : 1
FinalNewline : True
#>

#Requires -Version 3
[CmdletBinding()] Param(
# A file to examine.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
[Alias('FullName')][string] $Path
)
Begin
{
	function Read-Indent([hashtable]$indent,[IO.StreamReader]$sr)
	{
		if($sr.Peek() -notin 0x20,0x09) {return}
		$indent.count++
		$c = $sr.Read()
		$mixed = $false
		$firstspindent = !$indent.size -and $c -eq 0x20
		if($firstspindent) {$indent.size++}
		while($sr.Peek() -in 0x20,0x09)
		{
			$prev,$c = $c,$sr.Read()
			if($prev -ne $c) {$mixed = $true}
			if($firstspindent) {if($c -eq 0x20) {$indent.size++} else {$firstspindent = $false; $indent.size = 0}}
		}
		if($mixed) {$indent.htsp++} elseif($c -eq 0x20) {$indent.sp++} else {$indent.ht++}
		(Get-Variable prev -Scope 1).Value = if($prev) {$prev} else {$c}
	}
}
Process
{
	$crlf,$cr,$lf,$lines = 0,0,0,0
	$indent = @{ht=0;sp=0;htsp=0;count=0;size=0}
	$Path = Resolve-Path $Path
	$sr = New-Object IO.StreamReader $Path,$true
	for($c = $sr.Read(); !$sr.EndOfStream; $c = $sr.Read())
	{
		switch($c)
		{
			0x0A {$lines++; $lf++; Read-Indent $indent $sr}
			0x0D {$lines++; if($sr.Peek() -eq 0x0A) {$c = $sr.Read(); $crlf++} else {$cr++}; Read-Indent $indent $sr}
		}
		$prev = $c
	}
	$enc = $sr.CurrentEncoding.EncodingName
	$sr.Close(); $sr.Dispose(); $sr = $null
	foreach($i in 'ht','sp','htsp') {$indent.$i /= $indent.count}
	[pscustomobject]@{
		Path = $Path
		Encoding = $enc
		Lines = $lines
		LineEndings = 'CRLF','LF','CR' |where {Get-Variable $_ -ValueOnly}
		Indentation =
			if($indent.ht -and !($indent.sp -or $indent.htsp)) {'Tabs'}
			elseif($indent.sp -and !($indent.ht -or $indent.htsp)) {'Spaces'}
			else {'Mixed: {0:0%} tab, {1:0%} space, {2:0%} mixed' -f $indent['ht','sp','htsp']}
		IndentSize = if(!$indent.sp) {1} else {$indent.size}
		FinalNewline = $prev -in 0x0D,0x0A
	}
}
