<#
.SYNOPSIS
Returns the TODOs for the current git repo, which can help document technical debt.

.EXAMPLE
Get-Todos.ps1 |Out-GridView -Title "$((Get-Item $(git rev-parse --show-toplevel)).Name) TODOs"

Shows TODOs in this repo.
#>

#Requires -Version 3
[CmdletBinding()] Param()

Push-Location $(git rev-parse --show-toplevel)
Find-Lines.ps1 TODO * src -Simple -CaseSensitive |
    ForEach-Object {
        $blame = git blame -p -L "$($_.LineNumber),$($_.LineNumber)" -- $_.Path
        $author = $blame |Where-Object {$_ -match '^author (?<Author>.*)$'} |ForEach-Object {$Matches.Author}
        $Time = $blame |Where-Object {$_ -match '^author-time (?<Time>.*)$'} |ForEach-Object {(Get-Date 1970-01-01).AddSeconds([int]$Matches.Time)}
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
