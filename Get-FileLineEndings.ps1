<#
.Synopsis
	Determines a file's line endings.

.Parameter Path
	The location of a file.

.Inputs
	Any object with a Path or FullName property to use for a file location.

.Outputs
	System.String containing:

	* CRLF if the file only contains CRLF line endings.
	* LF if the file only contains LF line endings.
	* CR if the file only contains CR line endings.
	* Mixed (CRLF=n, LF=m, CR=k) if the file contains multiple different line endings.
	* None if the file contains no line endings.

.Link
	Get-FileEncoding.ps1

.Link
	Get-Content

.Example
	Get-FileLineEndings.ps1 Get-FileLineEndings.ps1

	CRLF
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)
Begin
{
	Set-Variable CR 0xD -Option Constant
	Set-Variable LF 0xA -Option Constant
}
Process
{
	$countCrLf,$countLf,$countCr = 0,0,0
	[scriptblock] $gc, [scriptblock] $toValue =
		if($PSVersionTable.PSEdition -eq 'Core')
		{
			switch((Get-FileEncoding.ps1 $Path).WebName)
			{
				'utf-16'   { {Get-Content $Path -ReadCount 2 -AsByteStream}.GetNewClosure(), {[bitconverter]::ToInt16($_,0)} }
				'utf-16be' { {Get-Content $Path -ReadCount 2 -AsByteStream}.GetNewClosure(), {[array]::Reverse($_);[bitconverter]::ToInt16($_,0)} }
				'utf-32'   { {Get-Content $Path -ReadCount 4 -AsByteStream}.GetNewClosure(), {[bitconverter]::ToInt32($_,0)} }
				'utf-32be' { {Get-Content $Path -ReadCount 4 -AsByteStream}.GetNewClosure(), {[array]::Reverse($_);[bitconverter]::ToInt32($_,0)} }
				default    { {Get-Content $Path -AsByteStream}.GetNewClosure(), {$_} }
			}
		}
		else
		{
			switch(Get-FileEncoding.ps1 $Path)
			{
				unicode          { {Get-Content $Path -ReadCount 2 -Encoding Byte}.GetNewClosure(), {[bitconverter]::ToInt16($_,0)} }
				bigendianunicode { {Get-Content $Path -ReadCount 2 -Encoding Byte}.GetNewClosure(), {[array]::Reverse($_);[bitconverter]::ToInt16($_,0)} }
				utf32            { {Get-Content $Path -ReadCount 4 -Encoding Byte}.GetNewClosure(), {[bitconverter]::ToInt32($_,0)} }
				utf32be          { {Get-Content $Path -ReadCount 4 -Encoding Byte}.GetNewClosure(), {[array]::Reverse($_);[bitconverter]::ToInt32($_,0)} }
				default          { {Get-Content $Path -Encoding Byte}.GetNewClosure(), {$_} }
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
	if($countCrLf) { if($countLf -or $countCr) {"Mixed (CRLF=$countCrLf, LF=$countLf, CR=$countCr)"} else {'CRLF'} }
	elseif($countLf) { if($countCr) {"Mixed (CRLF=$countCrLf, LF=$countLf, CR=$countCr)"} else {'LF'} }
	elseif($countCr) {'CR'}
	else {'None'}
}
