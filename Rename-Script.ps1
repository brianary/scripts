<#
.Synopsis
	Renames all instances of a script, and updates any usage of it.

.Parameter OldName
	The current name of the script to change.

.Parameter NewName
	The desired name of the script to change to.

.Parameter ScriptDirectory
	Any directories within which to rename the script (and any usage).

.Link
	Set-RegexReplace.ps1

.Example
	Rename-Script.ps1 Get-RomanNumeral.ps1 ConvertTo-RomanNumeral.ps1

	Renames the script file, and searches other script files for references to it,
	and updates them.
#>

#Requires -Version 3
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
[Parameter(Position=0,Mandatory=$true)][ValidateNotNullOrEmpty()][Alias('From')][string] $OldName,
[Parameter(Position=1,Mandatory=$true)][ValidateNotNullOrEmpty()][Alias('To')][string] $NewName,
[Parameter(Position=2,ValueFromRemainingArguments=$true)][ValidateNotNullOrEmpty()][Alias('Directory')]
[string[]] $ScriptDirectory = '.'
)

if($OldName -notlike '*.ps1') {$OldName += '.ps1'}
if($NewName -notlike '*.ps1') {$NewName += '.ps1'}

$i,$max = 0,(100/$ScriptDirectory.Length)
foreach($dir in $ScriptDirectory)
{
	$oldPath = Join-Path $dir $OldName
	Write-Progress "Renaming $OldName to $NewName" 'Finding script' -curr $dir -Percent ($i++/$max)
	if(!(Test-Path $oldPath -Type Leaf) -or !$PSCmdlet.ShouldProcess($oldPath,"Rename to $NewName")) {continue}
	Rename-Item $oldPath $NewName
}
Write-Progress "Renaming $OldName to $NewName" -Completed

Write-Progress "Updating uses of $OldName to $NewName" 'Finding uses'
$scope = $ScriptDirectory |foreach {"$_\*.ps1"}
[Microsoft.PowerShell.Commands.MatchInfo[]] $uses =
	@(Select-String "\b$([regex]::Escape([io.path]::GetFileNameWithoutExtension($OldName)))(?:\.ps1)?\b" $scope -List)
if($uses.Length -eq 0)
{
	Write-Warning "No uses of $OldName found!"
}
else
{
	$i,$max = 0,(100/$uses.Length)
	foreach($use in $uses)
	{
		Write-Progress "Updating uses of $OldName to $NewName" "Updating script $($use.Path)" -curr $use.Line `
			-Percent ($i++/$max)
		if(!$PSCmdlet.ShouldProcess("$use","Update to $NewName")) {continue}
		$use |Set-RegexReplace.ps1 $NewName
	}
}
Write-Progress "Updating uses of $OldName to $NewName" -Completed
