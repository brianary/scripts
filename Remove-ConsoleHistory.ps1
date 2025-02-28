<#
.SYNOPSIS
Removes an entry from the DOSKey-style console command history (up arrow or F8).

.INPUTS
System.String containing exact commands to remove.

.FUNCTIONALITY
Console

.EXAMPLE
Remove-ConsoleHistory.ps1 -Id 42

Deletes the 42nd command from the history.

.EXAMPLE
Remove-ConsoleHistory.ps1 -Duplicates

Deletes any repeated commands from the history.

.EXAMPLE
Remove-ConsoleHistory.ps1 -Like winget*

Deletes any commands that start with "winget" from the history.
#>

#Requires -Version 7
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
[Parameter(ParameterSetName='Id',Mandatory=$true)][int] $Id,
[Parameter(ParameterSetName='CommandLine',Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $CommandLine,
[Parameter(ParameterSetName='Like',Mandatory=$true)][string] $Like,
[Parameter(ParameterSetName='Duplicates',Mandatory=$true)][switch] $Duplicates
)
Begin
{
	$history = Get-PSReadLineOption |Select-Object -ExpandProperty HistorySavePath
}
Process
{
	switch($PSCmdlet.ParameterSetName)
	{
		Id
		{
			$cmd = Get-Content $history -TotalCount $Id |Select-Object -Last 1
			if($PSCmdlet.ShouldProcess($cmd, 'remove'))
			{
				$i = 1
				(Get-Content $history) |Where-Object {$i++ -ne $Id} |Out-File $history -Encoding utf8NoBOM
				Write-Verbose "Removed '$cmd'"
			}
		}
		CommandLine
		{
			[bool] $found = Get-Content $history |Where-Object {$_ -eq $CommandLine} |Select-Object -First 1
			if($found -and $PSCmdlet.ShouldProcess($CommandLine, 'remove'))
			{
				(Get-Content $history) -ne $CommandLine |Out-File $history -Encoding utf8NoBOM
				if($found) {Write-Verbose "Removed '$CommandLine'"}
			}
		}
		Like
		{
			$cmd = (Get-Content $history) -like $Like
			if($PSCmdlet.ShouldProcess("$($cmd.Count) commands matching '$Like'", 'remove'))
			{
				(Get-Content $history) -notlike $Like |Out-File $history -Encoding utf8NoBOM
				$cmd |ForEach-Object {Write-Verbose "Removed '$_'"}
			}
		}
		Duplicates
		{
			if($PSCmdlet.ShouldProcess('duplicate commands', 'remove'))
			{
				$before = (Get-Content $history).Count
				(Get-Content $history) |Select-Object -Unique |Out-File $history -Encoding utf8NoBOM
				$after = (Get-Content $history).Count
				Write-Verbose "Removed $($before - $after) duplicate entries"
			}
		}
	}
}
