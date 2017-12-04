<#
.Synopsis
    Adds GitHub Linguist overrides to a repo's .gitattributes.

.Parameter DefaultOwner
    Sets the code owner(s) by @username or email address to use when no more specific
    code owners are provided. By default, any authors within a standard deviation of
    the most commits will be included.

.Parameter Owners
    Maps .gitattribute-style globbing syntax for file matching to @username or email
    address of owners of any matching files.

.Parameter VendorCode
    A list of .gitattribute-style globbing syntax matches for files that should be
    considered vendor code, for files not covered by the default behavior of
    the default Linguist vendor code file glob patterns:
    https://github.com/github/linguist/blob/master/lib/linguist/vendor.yml

.Parameter DocumentationCode
    A list of .gitattribute-style globbing syntax matches for files that should be
    considered documentation, for files not covered by the default behavior of
    the default Linguist documentation file glob patterns:
    https://github.com/github/linguist/blob/master/lib/linguist/documentation.yml

.Parameter GeneratedCode
    A list of .gitattribute-style globbing syntax matches for files that should be
    considered generated code, for files not covered by the default behavior of
    the default Linguist generated code file glob patterns and contents matching:
    https://github.com/github/linguist/blob/master/lib/linguist/generated.rb

.Parameter IssueTemplate
    A Markdown string containing a template for creating issues.
    https://github.com/blog/2111-issue-and-pull-request-templates

.Parameter PullRequestTemplate
    A Markdown string containing a template for creating pull requests.
    https://github.com/blog/2111-issue-and-pull-request-templates

.Parameter ContributingFile
    The file path or URL containing guidelines for contributors in Markdown format.
    https://help.github.com/articles/setting-guidelines-for-repository-contributors/

.Parameter LicenseFile
    The file path or URL containing open source licensing for contributors in
    Markdown format.
    https://help.github.com/articles/adding-a-license-to-a-repository/

.Parameter DefaultCharset
    If no EditorConfig file exists, a simple default charset for text files in the
    repo. By default this is set to the system default, which is often terrible.

.Parameter DefaultLineEndings
    If no EditorConfig file exists, a simple default line endings value for text files
    in the repo. By default this is set to the system default, which is recommended.

.Parameter DefaultMaxLineLength
    If no EditorConfig file exists, a simple default max line length value for text
    files in the repo.

.Parameter DefaultIndentSize
    If no EditorConfig file exists, a simple default number of characters to indent
    lines for spaces (soft tabs) and tab display (hard tabs) for text files in the
    repo.

.Parameter DefaultUsesTabs
    If no EditorConfig file exists, this switch indicates a simple default for text
    files in the repo to use tabs. Otherwise, spaces will be used for indentation.

.Parameter DefaultKeepTrailingSpace
    If no EditorConfig file exists, this switch indicates a simple default for text
    files in the repo to preserve trailing spaces. Otherwise, trailing spaces will
    be trimmed.

.Parameter DefaultNoFinalNewLine
    If no EditorConfig file exists, this switch indicates a simple default for text
    files in the repo not to add a final line ending at the end. Otherwise, a final
    line ending will be added automatically if it is missing.

.Link
    https://github.com/blog/2392-introducing-code-owners

.Link
    https://github.com/github/linguist#overrides

.Link
    https://github.com/blog/2111-issue-and-pull-request-templates

.Link
    https://help.github.com/articles/setting-guidelines-for-repository-contributors/

.Link
    https://help.github.com/articles/adding-a-license-to-a-repository/

.Link
    http://editorconfig.org/

.Link
    Add-CaptureToMatches.ps1

.Link
    Measure-StandardDeviation.ps1

.Link
    Use-Command.ps1

.Example
    Add-LinguistOverrides.ps1
#>

#Requires -Version 3
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]Param(
[string[]]$DefaultOwner,
[hashtable]$Owners = @{},
[string[]]$VendorCode = @('packages/'),
[string[]]$DocumentationCode,
[string[]]$GeneratedCode = @('Reference.cs'),
[string]$IssueTemplate,
[string]$PullRequestTemplate,
[string]$ContributingFile,
[string]$LicenseFile,
[string]$DefaultCharset = ([Text.Encoding]::Default.WebName), #TODO: this is probably a terrible default 
[string]$DefaultLineEndings = $(switch([Environment]::NewLine){"`n"{'lf'}"`r"{'cr'}default{'crlf'}}),
[int]$DefaultMaxLineLength = 80,
[int]$DefaultIndentSize = 4,
[switch]$DefaultUsesTabs,
[switch]$DefaultKeepTrailingSpace,
[switch]$DefaultNoFinalNewLine
)

function Resolve-RepoPath
{
    [CmdletBinding()] Param([Parameter(ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string]$Path)
    Process { (Resolve-Path $Path -Relative) -replace '^.\\','' -replace '\\','/' }
}

function Test-SkipFile
{
    [CmdletBinding(SupportsShouldProcess=$true)] Param(
    [Parameter(Position=0)][string]$Filename
    )
    if((Test-Path $Filename) -and !$PSCmdlet.ShouldProcess($Filename,'overwrite'))
    { Write-Verbose "File $Filename exists!"; return $true }
    else
    { return $false }
}

function Copy-GitHubFile
{
    [CmdletBinding()] Param(
    [Parameter(Position=0,Mandatory=$true)][string]$Filename,
    [Parameter(Position=1,Mandatory=$true)][Alias('Path','Url')][uri]$Source
    )
    if(!"$Source"){ Write-Verbose "No file to copy."; return }
    else{Write-Host "$Source $($MyInvocation.CommandOrigin)" -ForegroundColor Cyan}
    if(Test-SkipFile $Filename){return}
    if($Source.IsFile){Copy-Item $Path $Filename}
    else{Invoke-WebRequest $Source -OutFile $Filename} #TODO: authentication for private repos?
}

function Add-GitHubDirectory
{
    if(!(Test-Path .github -PathType Container)) {mkdir .github |Out-Null}
}

function Add-File
{
    [CmdletBinding()] Param(
    [Parameter(Position=0,Mandatory=$true)][string]$Filename,
    [Parameter(Position=1,Mandatory=$true)][string]$Contents,
    [switch]$Warn,
    [switch]$Force
    )
    if(!$Contents){Write-Verbose "No contents to add to $Filename."; return }
    if(!$Force -and (Test-SkipFile $Filename)){ Write-Verbose "File $Filename exists!"; return }
    $Contents |Out-File $Filename -Encoding utf8
    git add -N $Filename |Out-Null
    if($Warn){ Write-Warning "The file $Filename has been added, be sure to review it and customize as needed." }
    Write-Verbose "Added $Filename"
}

function Add-Readme
{
    Add-File README.md @"
$name
$(New-Object string '=',($name.Length))

TODO: Summarize purpose of repo contents here.

Sections
--------

TODO: Add sections for additional details, special instructions, prerequisites, &c.
"@ -Warn
}

function Add-CodeOwners
{
    if(Test-SkipFile .github/CODEOWNERS){return}
    if(!$DefaultOwner)
    {
        Write-Verbose 'Determining default code owner(s).'
        $authors = git shortlog -nes |
            Select-String '^\s*(?<Commits>\d+)\s+(?<Name>\b[^>]+\b)\s+<(?<Email>[^>]+)>$' |
            Add-CapturesToMatches.ps1
        $authors |Out-String |Write-Verbose
        [int]$max = ($authors |measure Commits -Maximum).Maximum
        [int]$oneSigmaFromTop = $max - (Measure-StandardDeviation.ps1 $authors.Commits)
        Write-Verbose "Authors with more than $oneSigmaFromTop commits will be included as default code owners."
        $DefaultOwner = $authors |? {[int]$_.Commits -gt $oneSigmaFromTop} |% Email
        Write-Verbose "Default code owners determined to be $DefaultOwner."
    }
    Add-File .github/CODEOWNERS @"
# Code Owners file https://github.com/blog/2392-introducing-code-owners
# .gitattributes selection syntax mapping to GitHub @usernames or email addresses.

# default owner(s)
* $DefaultOwner
$(if($Owners){'','# targeted owners' -join "`r`n"})
$($Owners.Keys |% {"$_ $($Owners[$_] -join ' ')"})
"@ -Warn -Force
}

function Add-LinguistOverrides
{
    [CmdletBinding(SupportsShouldProcess=$true)] Param()
    if(!(Test-Path .gitattributes -PathType Leaf))
    {
        Write-Verbose 'Creating .gitattributes file.'
        '# Linguist overrides https://github.com/github/linguist#overrides' |Out-File .gitattributes utf8
    }
    else
    {
        if(Select-String '^# Linguist overrides' .gitattributes)
        {
            Select-String '^# Linguist overrides|\blinguist-\w+' .gitattributes |Out-String |Write-Verbose
            if(!$PSCmdlet.ShouldContinue('.gitattributes','append Linguist overrides'))
            {
                Write-Verbose 'The .gitattributes file already contains a "Linguist overrides" section.'
                return
            }
        }
        else
        {
            '','# Linguist overrides https://github.com/github/linguist#overrides' |Add-Content .gitattributes -Encoding UTF8
        }
    }
    $VendorCode |% {"$_ linguist-vendored"} |Add-Content .gitattributes -Encoding UTF8
    $DocumentationCode |% {"$_ linguist-documentation"} |Add-Content .gitattributes -Encoding UTF8
    $GeneratedCode |% {"$_ linguist-generated=true"} |Add-Content .gitattributes -Encoding UTF8
    #TODO: linguist-language entries?
    git add -N .gitattributes |Out-Null
    Write-Verbose 'Added Linguist overrides section to .gitattributes.'
    Select-String '^# Linguist overrides|\blinguist-\w+' .gitattributes |Out-String |Write-Verbose
}

function Add-IssueTemplate
{
    Add-File .github/ISSUE_TEMPLATE.md $IssueTemplate
}

function Add-PullRequestTemplate
{
    Add-File .github/PULL_REQUEST_TEMPLATE.md $PullRequestTemplate
}

function Add-ContributingGuidelines
{
    Copy-GitHubFile .github/CONTRIBUTING.md $ContributingFile
}

function Add-License
{
    Copy-GitHubFile LICENSE.md $LicenseFile
}

function Add-EditorConfig
{
    Add-File .editorconfig @"
# EditorConfig is awesome: http://EditorConfig.org

# last word for the project
root = true

# defaults
[*]
indent_style             = $(if($DefaultUsesTabs){'tab'}else{'space'})
indent_size              = $DefaultIndentSize
tab_width                = $DefaultIndentSize
end_of_line              = $DefaultLineEndings
charset                  = $DefaultCharset
trim_trailing_whitespace = $(if($DefaultKeepTrailingSpace){'false'}else{'true'})
insert_final_newline     = $(if($DefaultNoFinalNewLine){'false'}else{'true'})
"@ -Warn
}

function Update-GitHubMetadata
{
    Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -choco git
    Push-Location $(git rev-parse --show-toplevel)
    Add-GitHubDirectory
    Add-Readme
    Add-CodeOwners
    Add-LinguistOverrides
    Add-IssueTemplate
    Add-PullRequestTemplate
    Add-ContributingGuidelines
    Add-License
    Add-EditorConfig
    Pop-Location
}

Update-GitHubMetadata
