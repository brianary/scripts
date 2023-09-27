<#
.SYNOPSIS
Returns the TODOs for the current git repo, which can help document technical debt.

.EXAMPLE
Get-Todos.ps1 |Out-GridView -Title "$((Get-Item $(git rev-parse --show-toplevel)).Name) TODOs"

Shows TODOs in this repo.
#>

#Requires -Version 7
[CmdletBinding()] Param()

Push-Location $(git rev-parse --show-toplevel)
Find-Lines.ps1 -Pattern '\bTODO\b' -Filters * -Path ((Test-Path src -Type Container) ? 'src' : '.') -CaseSensitive |
	ForEach-Object {
		[string[]] $blame = git blame -p -L "$($_.LineNumber),$($_.LineNumber)" -- $_.Path
		$author = $blame |Select-String '^author (?<Author>.*)$' |Select-CapturesFromMatches.ps1 -ValuesOnly
		$Time = $blame |Select-String '^author-time (?<Time>.*)$' |Select-CapturesFromMatches.ps1 -ValuesOnly |
			ConvertFrom-EpochTime.ps1
		[pscustomobject]@{
			Author = $author
			Time = $time
			Todo = ($_.Line -split 'TODO:?\s*',2)[1].Trim()
			Path = Resolve-Path $_.Path -Relative
			LineNumber = $_.LineNumber
		}
	} |
	Sort-Object Time -Descending
Pop-Location
