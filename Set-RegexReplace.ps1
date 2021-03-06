<#
.Synopsis
	Updates text found with Select-String, using a regular expression replacement template.

.Parameter Replacement
	A regular expression replacement string.

	* $$ is a literal $
	* $_ is the entire input string.
	* $` is the string before the match.
	* $& is the entire matching string.
	* $' is the string after the match.
	* $1 is the first matching group.
	* $n (where n is a number) is the nth matching group.
	* $name is the group named "name".
	* $+ is the last matching group.

.Parameter InputObject
	The output from Select-String.

.Inputs
	Microsoft.PowerShell.Commands.MatchInfo containing a regex match than will be replaced.

.Outputs
	System.String of the input string if the Select-String's input was a string instead of a file.
	(File changes will be saved back to the file.)

.Link
	https://docs.microsoft.com/dotnet/standard/base-types/substitutions-in-regular-expressions

.Link
	Get-Encoding.ps1

.Example
	Select-String '(<!-- generated) .*? (-->)' README.md |Set-RegexReplace.ps1 "`$1 $(Get-Date) `$2"

	Updates the generated date in README.md.

.Example
	Get-Item README.md |select Name,Length |ConvertTo-Html -Fragment |Out-String |Select-String '(<td)(>\d+</td>)' |Set-RegexReplace.ps1 '$1 align="right"$2'

	<table>
	<colgroup><col/><col/></colgroup>
	<tr><th>Name</th><th>Length</th></tr>
	<tr><td>README.md</td><td align="right">21099</td></tr>
	</table>
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Replacement,
[Parameter(ValueFromPipeline=$true)][Microsoft.PowerShell.Commands.MatchInfo] $InputObject
)
Begin
{
	Write-Verbose 'Begin'
	$files = @{}
}
Process
{
	Write-Verbose 'Process'
	if($InputObject.Path -eq 'InputStream')
	{
		Write-Verbose "Line: $($InputObject.Line)"
		if($InputObject.Context -eq $null)
		{
			return ($InputObject.Line -replace $InputObject.Pattern,$Replacement)
		}
		else
		{
			return ($InputObject.Context.PreContext,
				($InputObject.Line -replace $InputObject.Pattern,$Replacement),
				$InputObject.Context.PostContext |Out-String)
		}
	}
	elseif(!$files.ContainsKey($InputObject.Path))
	{
		Write-Verbose "Adding '$($InputObject.Path)'"
		$files.Add($InputObject.Path,$InputObject.Pattern)
	}
	else
	{
		Write-Verbose "Already added '$($InputObject.Path)'"
	}
}
End
{
	Write-Verbose 'End'
	$i,$max = 0,($files.Count/100)
	Write-Verbose "Updating $($files.Count) files"
	foreach($file in $files.Keys)
	{
		$pattern = $files[$file]
		Write-Progress 'Performing file replace' "$pattern" -curr $file -percent ($i++/$max)
		Write-Verbose "$Path : -replace '$Pattern','$Replacement'"
		(Get-Content $file -Raw) -replace $pattern,$Replacement |Out-File $file (Get-Encoding.ps1 $file)
	}
	Write-Progress 'Performing file replace' 'Complete' -Completed
}
