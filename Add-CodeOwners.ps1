<#
.Synopsis
    Adds a file to indicate GitHub code owners for a repo.

.Parameter DefaultOwner
    The default owner(s) for the repo, either @usernames or email addresses.

.Parameter Owners
    A hashtable of .gitattribute-style selectors (e.g. *.sql or database/)
    mapped to owner(s).

.Parameter Force
    Overwrite an existing code owners file.

.Link
    Use-Command.ps1

.Link
    Measure-StandardDeviation.ps1

.Example
    Add-CodeOwners.ps1

    Adds .github/CODEOWNERS to the root of the repo, with the most prolific
    contributor as the default code owner.

.Example
    Add-CodeOwners.ps1 -DefaultOwner zaphodb@example.net -Owners @{'*.sql'='trillian@example.com'}

    Adds .github/CODEOWNERS to the root of the repo, with the specified
    contributor as the default code owner, and specified other owners.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0)][string[]]$DefaultOwner,
[Parameter(Position=1)][hashtable]$Owners,
[switch]$Force
)

if((Test-Path .github/CODEOWNERS -PathType Leaf) -and !$Force){throw "Code owners file already exists!"}
Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -choco git
Push-Location $(git rev-parse --show-toplevel)
if(!$DefaultOwner)
{
    $authors = git shortlog -nes |
        Select-String '^\s*(?<Commits>\d+)\s+(?<Name>\b[^>]+\b)\s+<(?<Email>[^>]+)>$' |
        Add-CapturesToMatches.ps1
    $authors |Out-String |Write-Verbose
    [int]$max = ($authors |measure Commits -Maximum).Maximum
    [int]$oneSigmaFromTop = $max - (Measure-StandardDeviation.ps1 $authors.Commits)
    Write-Verbose "Authors with more than $oneSigmaFromTop commits will be included."
    $DefaultOwner = $authors |? {[int]$_.Commits -gt $oneSigmaFromTop} |% Email
    Write-Verbose "Owners determined to be $DefaultOwner"
}
if(!(Test-Path .github -PathType Container)) {mkdir .github |Out-Null}
@"
# Code Owners file https://github.com/blog/2392-introducing-code-owners
# .gitattributes selection syntax mapping to GitHub @usernames or email addresses.

# default owner(s)
* $DefaultOwner
"@ |Out-File .github/CODEOWNERS utf8
if($Owners)
{
    $Local:OFS = "`r`n"
@"

# targeted owners
$($Owners.Keys |% {"$_ $($Owners[$_] -join ' ')"})
"@ |Add-Content .github/CODEOWNERS -Encoding UTF8
}
gc .github/CODEOWNERS -Raw |Write-Verbose
git add -N .github/CODEOWNERS
Pop-Location
