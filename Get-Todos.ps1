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
    foreach {
        $blame = git blame -p -L "$($_.LineNumber),$($_.LineNumber)" -- $_.Path
        $author = $blame |where {$_ -match '^author (?<Author>.*)$'} |foreach {$Matches.Author}
        $Time = $blame |where {$_ -match '^author-time (?<Time>.*)$'} |foreach {(Get-Date 1970-01-01).AddSeconds([int]$Matches.Time)}
        [pscustomobject]@{
            Author = $author
            Time = $time
            Todo = ($_.Line -split 'TODO:?\s*',2)[1].Trim()
            Path = Resolve-Path $_.Path -Relative
            LineNumber = $_.LineNumber
        }
    } |
    sort Time -Descending
Pop-Location
