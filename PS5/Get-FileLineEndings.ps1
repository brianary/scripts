<#
.SYNOPSIS
Determines a file's line endings.

.PARAMETER Path
The location of a file.

.INPUTS
Any object with a Path or FullName property to use for a file location.

.OUTPUTS
System.Management.Automation.PSCustomObject with the following properties:

* Path, a string containing the location of the file.
* LineEndings, one of: CRLF, LF, CR, Mixed or None.
* CRLF, a count of the CR LF line endings found.
* LF, a count of the LF line endings found.
* CR, a count of the CR line endings found.

.LINK
Get-FileEncoding.ps1

.LINK
Get-Content

.EXAMPLE
Get-FileLineEndings.ps1 Get-FileLineEndings.ps1

Path        : A:\scripts\Get-FileLineEndings.ps1
LineEndings : CRLF
CRLF        : 90
LF          : 0
CR          : 0
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[Alias('FullName')][string] $Path
)
Begin
{
	Set-Variable CR 0xD -Option Constant
	Set-Variable LF 0xA -Option Constant
}
Process
{
	foreach($file in (Resolve-Path $Path).Path)
	{
		$countCrLf,$countLf,$countCr = 0,0,0
		[scriptblock] $gc, [scriptblock] $toValue =
			if($PSVersionTable.PSEdition -eq 'Core')
			{
				switch((Get-FileEncoding.ps1 $file).WebName)
				{
					'utf-16'   { {Get-Content $file -ReadCount 2 -AsByteStream}.GetNewClosure(), {[bitconverter]::ToInt16($_,0)} }
					'utf-16be' { {Get-Content $file -ReadCount 2 -AsByteStream}.GetNewClosure(), {[array]::Reverse($_);[bitconverter]::ToInt16($_,0)} }
					'utf-32'   { {Get-Content $file -ReadCount 4 -AsByteStream}.GetNewClosure(), {[bitconverter]::ToInt32($_,0)} }
					'utf-32be' { {Get-Content $file -ReadCount 4 -AsByteStream}.GetNewClosure(), {[array]::Reverse($_);[bitconverter]::ToInt32($_,0)} }
					default    { {Get-Content $file -AsByteStream}.GetNewClosure(), {$_} }
				}
			}
			else
			{
				switch(Get-FileEncoding.ps1 $file)
				{
					unicode          { {Get-Content $file -ReadCount 2 -Encoding Byte}.GetNewClosure(), {[bitconverter]::ToInt16($_,0)} }
					bigendianunicode { {Get-Content $file -ReadCount 2 -Encoding Byte}.GetNewClosure(), {[array]::Reverse($_);[bitconverter]::ToInt16($_,0)} }
					utf32            { {Get-Content $file -ReadCount 4 -Encoding Byte}.GetNewClosure(), {[bitconverter]::ToInt32($_,0)} }
					utf32be          { {Get-Content $file -ReadCount 4 -Encoding Byte}.GetNewClosure(), {[array]::Reverse($_);[bitconverter]::ToInt32($_,0)} }
					default          { {Get-Content $file -Encoding Byte}.GetNewClosure(), {$_} }
				}
			}
		$prev = $null
		foreach($c in $gc.InvokeReturnAsIs() |foreach $toValue)
		{
			if($c -eq $LF) { if($prev -eq $CR) {$countCrLf++} else {$countLf++} }
			elseif($prev -eq $CR) {$countCr++}
			$prev = $c
		}
		Write-Verbose "EOL counts: CRLF=$countCrLf, LF=$countLf, CR=$countCr"
		$lineEndings =
			if($countCrLf) { if($countLf -or $countCr) {'Mixed'} else {'CRLF'} }
			elseif($countLf) { if($countCr) {'Mixed'} else {'LF'} }
			elseif($countCr) {'CR'}
			else {'None'}
		[pscustomobject]@{
			Path        = $file
			LineEndings = $lineEndings
			CRLF        = $countCrLf
			LF          = $countLF
			CR          = $countCr
		} |Add-Member ScriptMethod ToString -Force -PassThru {$this.LineEndings}
	}
}
