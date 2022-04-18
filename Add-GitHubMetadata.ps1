<#
.SYNOPSIS
Adds GitHub Linguist overrides to a repo's .gitattributes.

.LINK
https://github.com/blog/2392-introducing-code-owners

.LINK
https://github.com/github/linguist#overrides

.LINK
https://github.com/blog/2111-issue-and-pull-request-templates

.LINK
https://help.github.com/articles/setting-guidelines-for-repository-contributors/

.LINK
https://help.github.com/articles/adding-a-license-to-a-repository/

.LINK
http://editorconfig.org/

.LINK
https://github.com/brianary/Detextive/

.LINK
Add-CapturesToMatches.ps1

.LINK
Measure-StandardDeviation.ps1

.LINK
Test-FileTypeMagicNumber.ps1

.LINK
Use-Command.ps1

.EXAMPLE
Add-GitHubMetadata.ps1 -DefaultOwner arthurd@example.com -DefaultUsesTabs

Sets up the CODEOWNERS file and assigns a user, and sets the indent default.
#>

#Requires -Version 3
#Requires -Modules Detextive
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')][OutputType([void])] Param(
<#
Sets the code owner(s) by @username or email address to use when no more specific
code owners are provided. By default, any authors within a standard deviation of
the most commits will be included.
#>
[string[]] $DefaultOwner,
<#
Maps .gitattribute-style globbing syntax for file matching to @username or email
address of owners of any matching files.
#>
[hashtable] $Owners = @{},
<#
A list of .gitattribute-style globbing syntax matches for files that should be
considered vendor code, for files not covered by the default behavior of
the default Linguist vendor code file glob patterns:
https://github.com/github/linguist/blob/master/lib/linguist/vendor.yml
#>
[string[]] $VendorCode = @('**/packages/**','**/lib/**'),
<#
A list of .gitattribute-style globbing syntax matches for files that should be
considered documentation, for files not covered by the default behavior of
the default Linguist documentation file glob patterns:
https://github.com/github/linguist/blob/master/lib/linguist/documentation.yml
#>
[string[]] $DocumentationCode,
<#
A list of .gitattribute-style globbing syntax matches for files that should be
considered generated code, for files not covered by the default behavior of
the default Linguist generated code file glob patterns and contents matching:
https://github.com/github/linguist/blob/master/lib/linguist/generated.rb
#>
[string[]] $GeneratedCode = @('"**/Service References/**"','"**/Web References/**"'),
<#
A Markdown string containing a template for creating issues.
https://github.com/blog/2111-issue-and-pull-request-templates
#>
[string] $IssueTemplate,
<#
A Markdown string containing a template for creating pull requests.
https://github.com/blog/2111-issue-and-pull-request-templates
#>
[string] $PullRequestTemplate,
<#
The file path or URL containing guidelines for contributors in Markdown format.
https://help.github.com/articles/setting-guidelines-for-repository-contributors/
#>
[string] $ContributingFile,
<#
The file path or URL containing open source licensing for contributors in
Markdown format.
https://help.github.com/articles/adding-a-license-to-a-repository/
#>
[string] $LicenseFile,
<#
If no EditorConfig file exists, a simple default charset for text files in the
repo. By default this is set to the system default, which is often terrible.
#>
[string] $DefaultCharset = $OutputEncoding.WebName,
<#
If no EditorConfig file exists, a simple default line endings value for text files
in the repo. By default this is set to the system default, which is recommended.
#>
[string] $DefaultLineEndings = $(switch([Environment]::NewLine){"`n"{'lf'}"`r"{'cr'}default{'crlf'}}),
<#
If no EditorConfig file exists, a simple default number of characters to indent
lines for spaces (soft tabs) and tab display (hard tabs) for text files in the
repo.
#>
[int] $DefaultIndentSize = 4,
<#
If no EditorConfig file exists, this switch indicates a simple default for text
files in the repo to use tabs. Otherwise, spaces will be used for indentation.
#>
[switch] $DefaultUsesTabs,
<#
If no EditorConfig file exists, this switch indicates a simple default for text
files in the repo to preserve trailing spaces. Otherwise, trailing spaces will
be trimmed.
#>
[switch] $DefaultKeepTrailingSpace,
<#
If no EditorConfig file exists, this switch indicates a simple default for text
files in the repo not to add a final line ending at the end. Otherwise, a final
line ending will be added automatically if it is missing.
#>
[switch] $DefaultNoFinalNewLine
)

function Resolve-RepoPath
{
    [CmdletBinding()] Param([Parameter(ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path)
    Process { (Resolve-Path $Path -Relative) -replace '^.\\','' -replace '\\','/' }
}

function Test-SkipFile
{
    [CmdletBinding(SupportsShouldProcess=$true)] Param(
    [Parameter(Position=0)][string] $Filename
    )
    if((Test-Path $Filename) -and !$PSCmdlet.ShouldProcess($Filename,'overwrite'))
    { Write-Verbose "File $Filename exists!"; return $true }
    else
    { return $false }
}

function Copy-GitHubFile
{
    [CmdletBinding()] Param(
    [Parameter(Position=0,Mandatory=$true)][string] $Filename,
    [Parameter(Position=1,Mandatory=$true)][Alias('Path','Url')][uri] $Source
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
    [Parameter(Position=0,Mandatory=$true)][string] $Filename,
    [Parameter(Position=1,Mandatory=$true)][string] $Contents,
    [Parameter(Position=2)][ValidateSet('utf8','ASCII')][string] $Encoding = 'utf8',
    [switch] $Warn,
    [switch] $Force
    )
    if(!$Contents){Write-Verbose "No contents to add to $Filename."; return }
    if(!$Force -and (Test-SkipFile $Filename)){ Write-Verbose "File $Filename exists!"; return }
    $Contents |Out-File $Filename -Encoding $Encoding
    git add -N $Filename |Out-Null
    if($Warn){ Write-Warning "The file $Filename has been added, be sure to review it and customize as needed." }
    Write-Verbose "Added $Filename"
}

function Add-Readme([string] $name = (git rev-parse --show-toplevel |Split-Path -Leaf))
{
    if(Test-Path README.md -PathType Leaf){return}
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
    if(Test-SkipFile .github/CODEOWNERS)
    {
        if(Test-FileTypeMagicNumber.ps1 utf8 .github/CODEOWNERS){Remove-Utf8Signature .github/CODEOWNERS}
        return
    }
    if(!$DefaultOwner)
    {
        Write-Verbose 'Determining default code owner(s).'
        $authors = git shortlog -nes |
            Select-String '^\s*(?<Commits>\d+)\s+(?<Name>\b[^>]+\b)\s+<(?<Email>[^>]+)>$' |
            Add-CapturesToMatches.ps1
        $authors |Out-String |Write-Verbose
        [int] $max = ($authors |measure Commits -Maximum).Maximum
        [int] $oneSigmaFromTop = $max - (Measure-StandardDeviation.ps1 $authors.Commits)
        Write-Verbose "Authors with $oneSigmaFromTop or more commits will be included as default code owners."
        $DefaultOwner = $authors |? {[int] $_.Commits -ge $oneSigmaFromTop} |% Email
        Write-Verbose "Default code owners determined to be $DefaultOwner."
    }
    Add-File .github/CODEOWNERS @"

# Code Owners file https://github.com/blog/2392-introducing-code-owners
# .gitattributes selection syntax mapping to GitHub @usernames or email addresses.

# default owner(s)
* $DefaultOwner
$(if($Owners){'','# targeted owners' -join [environment]::NewLine})
$($Owners.Keys |% {"$_ $($Owners[$_] -join ' ')"})
"@ ASCII -Warn -Force
}

function Add-LinguistOverrides
{
    [CmdletBinding(SupportsShouldProcess=$true)] Param()
    if(!(Test-Path .gitattributes -PathType Leaf))
    {
        Write-Verbose 'Creating .gitattributes file.'
        '','# Linguist overrides https://github.com/github/linguist#overrides' |Out-File .gitattributes ascii
    }
    else
    {
        if(Test-FileTypeMagicNumber.ps1 utf8 .gitattributes){Remove-Utf8Signature .gitattributes}
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
    if($VendorCode) {$VendorCode |% {"$_ linguist-vendored"} |Add-Content .gitattributes -Encoding UTF8}
    if($DocumentationCode) {$DocumentationCode |% {"$_ linguist-documentation"} |Add-Content .gitattributes -Encoding UTF8}
    if($GeneratedCode) {$GeneratedCode |% {"$_ linguist-generated=true"} |Add-Content .gitattributes -Encoding UTF8}
    #TODO: linguist-language entries?
    git add -N .gitattributes |Out-Null
    Write-Verbose 'Added Linguist overrides section to .gitattributes.'
    Select-String '^# Linguist overrides|\blinguist-\w+' .gitattributes |Out-String |Write-Verbose
}

function Add-IssueTemplate
{
    if(!$IssueTemplate){Write-Verbose 'No issue template.'; return}
    Add-File .github/ISSUE_TEMPLATE.md $IssueTemplate
}

function Add-PullRequestTemplate
{
    if(!$PullRequestTemplate){Write-Verbose 'No pull request template.'; return}
    Add-File .github/PULL_REQUEST_TEMPLATE.md $PullRequestTemplate
}

function Add-ContributingGuidelines
{
    if(!$ContributingFile){Write-Verbose 'No contributing file.'; return}
    Copy-GitHubFile .github/CONTRIBUTING.md $ContributingFile
}

function Add-License
{
    if(!$LicenseFile){Write-Verbose 'No license.'; return}
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

# git
[{.gitattributes,CODEOWNERS}]
charset = utf-8

# CSS
# https://www.w3.org/International/questions/qa-utf8-bom.en#bytheway
[*.css]
charset = utf-8

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
