<#
.SYNOPSIS
Adds GitHub Linguist overrides to a repo's .gitattributes.

.DESCRIPTION
There is a lot of metadata that should be added to a good repo.
This script simplifies adding much of that metadata.

.FUNCTIONALITY
Git and GitHub

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
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','',
Justification='These plural nouns work with groups.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter','',
Justification='Parameters are not tracked accurately.')]
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
[switch] $DefaultNoFinalNewLine,
# Indicates warnings about new content should be skipped.
[switch] $NoWarnings,
# Configure VSCode settings to recommend relevant extensions based on repo content.
[Alias('Recommendations')][switch] $VsCodeExtensionRecommendations,
<#
Configure VSCode settings to disable the Prettier extension for Markdown files,
since Prettier's formatting settings are not configurable, and some break Markdown
for some interpreters (e.g. lower-casing footnote links is incompatible with GitHub Pages),
and some formatting choices may not be desirable or may conflict with organizational
standards.
#>
[Alias('DisablePrettierMarkdown','NoPrettierMarkdown')][switch] $VSCodeDisablePrettierForMarkdown,
# Configure settings for Dev Containers, used for Codespaces.
[Alias('Codespaces')][switch] $DevContainer,
# Disables adding or updating the CODEOWNERS file.
[switch] $NoOwners,
# Do not prompt to append Linguist settings.
[switch] $Force
)

function Resolve-RepoPath
{
	[CmdletBinding()] Param([Parameter(ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path)
	Process { (Resolve-Path $Path -Relative) -replace '^.\\','' -replace '\\','/' }
}

function Test-KeepFile
{
	[CmdletBinding(SupportsShouldProcess=$true)][OutputType([bool])] Param(
	[Parameter(Position=0)][string] $Filename,
	[switch] $Keep
	)
	$exists = Test-Path $Filename -Type Leaf
	if($exists -and $Keep) { Write-Verbose "Keeping existing $Filename"; return $true }
	if(!$exists) { return $false }
	Write-Verbose "$Filename exists"
	return !$PSCmdlet.ShouldProcess($Filename,'overwrite')
}

function Copy-GitHubFile
{
	[CmdletBinding()] Param(
	[Parameter(Position=0,Mandatory=$true)][string] $Filename,
	[Parameter(Position=1,Mandatory=$true)][Alias('Path','Url')][uri] $Source
	)
	if(Test-KeepFile $Filename){return}
	if($Source.IsFile){Copy-Item $Source.LocalPath $Filename}
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
	[switch] $Keep,
	[switch] $Force
	)
	if($Keep -and (Test-Path $Filename -Type Leaf)) { return }
	if(!$Contents){Write-Verbose "No contents to add to $Filename."; return }
	if(!$Force -and (Test-KeepFile $Filename)){ Write-Verbose "File $Filename exists!"; return }
	$Contents |Out-File $Filename -Encoding $Encoding
	git add -N $Filename |Out-Null
	if($Warn){ Write-Warning "The file $Filename has been added, be sure to review it and customize as needed." }
	Write-Verbose "Added $Filename"
}

function Add-Readme([string] $name = (git rev-parse --show-toplevel |Split-Path -Leaf), [switch] $NoWarnings)
{
	if(Test-Path README.md -PathType Leaf){return}
	Add-File README.md @"
$name
$(New-Object string '=',($name.Length))

TODO: Summarize purpose of repo contents here.

Sections
--------

TODO: Add sections for additional details, special instructions, prerequisites, &c.
"@ -Warn:$(!$NoWarnings)
}

function Add-CodeOwners
{
	Param(
	[string[]] $DefaultOwner,
	[hashtable] $Owners,
	[switch] $NoWarnings
	)
	if(Test-KeepFile .github/CODEOWNERS -Keep:(!$DefaultOwner -and !$Owners))
	{
		if(Test-FileTypeMagicNumber.ps1 utf8 .github/CODEOWNERS){Remove-Utf8Signature .github/CODEOWNERS}
		return
	}
	if(!$DefaultOwner)
	{
		Write-Verbose 'Determining default code owner(s).'
		$authors = git shortlog -nes HEAD |
			Select-String '^\s*(?<Commits>\d+)\s+(?<Name>\b[^>]+\b)\s+<(?<Email>[^>]+)>$' |
			Add-CapturesToMatches.ps1
		$authors |Out-String |Write-Verbose
		[int] $max = ($authors |Measure-Object Commits -Maximum).Maximum
		[int] $oneSigmaFromTop = $max - ($authors.Commits |Measure-StandardDeviation.ps1)
		Write-Verbose "Authors with $oneSigmaFromTop or more commits will be included as default code owners."
		$DefaultOwner = $authors |Where-Object {[int] $_.Commits -ge $oneSigmaFromTop} |Select-Object -ExpandProperty Email
		Write-Verbose "Default code owners determined to be $DefaultOwner."
	}
	$Local:OFS = [Environment]::NewLine
	Add-File -Filename .github/CODEOWNERS -Contents @"

# Code Owners file https://github.com/blog/2392-introducing-code-owners
# .gitattributes selection syntax mapping to GitHub @usernames or email addresses.

# default owner(s)
* $DefaultOwner
$(if($Owners){"$OFS# targeted owners"})
$($Owners.Keys |ForEach-Object {"$_ $($Owners[$_] -join ' ')"})
"@ -Encoding ASCII -Warn:$(!$NoWarnings) -Force
}

function Add-LinguistOverrides
{
	[CmdletBinding(SupportsShouldProcess=$true)] Param(
	[string[]] $VendorCode,
	[string[]] $DocumentationCode,
	[string[]] $GeneratedCode,
	[switch] $Force
	)
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
			if(!$Force -and !$PSCmdlet.ShouldContinue('.gitattributes','append Linguist overrides'))
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
	if($VendorCode) {$VendorCode |ForEach-Object {"$_ linguist-vendored"} |Add-Content .gitattributes -Encoding UTF8}
	if($DocumentationCode) {$DocumentationCode |ForEach-Object {"$_ linguist-documentation"} |Add-Content .gitattributes -Encoding UTF8}
	if($GeneratedCode) {$GeneratedCode |ForEach-Object {"$_ linguist-generated=true"} |Add-Content .gitattributes -Encoding UTF8}
	#TODO: linguist-language entries?
	git add -N .gitattributes |Out-Null
	Write-Verbose 'Added Linguist overrides section to .gitattributes.'
	Select-String '^# Linguist overrides|\blinguist-\w+' .gitattributes |Out-String |Write-Verbose
}

function Add-IssueTemplate([string] $IssueTemplate)
{
	if(!$IssueTemplate){Write-Verbose 'No issue template.'; return}
	Add-File .github/ISSUE_TEMPLATE.md $IssueTemplate
}

function Add-PullRequestTemplate([string] $PullRequestTemplate)
{
	if(!$PullRequestTemplate){Write-Verbose 'No pull request template.'; return}
	Add-File .github/PULL_REQUEST_TEMPLATE.md $PullRequestTemplate
}

function Add-ContributingGuidelines([string] $ContributingFile)
{
	if(!$ContributingFile){Write-Verbose 'No contributing file.'; return}
	Copy-GitHubFile .github/CONTRIBUTING.md $ContributingFile
}

function Add-License([string] $LicenseFile)
{
	if(!$LicenseFile){Write-Verbose 'No license.'; return}
	Copy-GitHubFile LICENSE.md $LicenseFile
}

function Add-EditorConfig
{
	Param(
	[string] $DefaultCharset,
	[string] $DefaultLineEndings,
	[int] $DefaultIndentSize,
	[switch] $DefaultUsesTabs,
	[switch] $DefaultKeepTrailingSpace,
	[switch] $DefaultNoFinalNewLine,
	[switch] $NoWarnings
	)
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

"@ -Warn:$(!$NoWarnings) -Keep
}

function Add-VsCodeExtensionRecommendations
{
	if(!(Test-Path .vscode -PathType Container)) {mkdir .vscode |Out-Null}
	$recommendations = New-Object Collections.Generic.HashSet[string]
	[string[]] $previous = Get-VSCodeSetting.ps1 recommendations -Workspace
	if($previous) {$previous |ForEach-Object {[void]$recommendations.Add($_)}}
	if((Test-Path .github -Type Container) -and (Test-Path .github/workflows -Type Container) -and
		(Get-ChildItem .github/workflows -Filter *.yml |Select-Object -First 1))
	{
		[void]$recommendations.Add('GitHub.vscode-github-actions')
	}
	[void]$recommendations.Add('yzhang.markdown-all-in-one')
	[void]$recommendations.Add('EditorConfig.EditorConfig')
	if(Get-ChildItem -Recurse -Filter *.md |Select-String '```mermaid' |Select-Object -First 1)
	{
		[void]$recommendations.Add('bierner.markdown-mermaid')
		[void]$recommendations.Add('bpruitt-goddard.mermaid-markdown-syntax-highlighting')
	}
	if(Get-ChildItem -Recurse -Filter *.adoc |Select-Object -First 1)
	{
		[void]$recommendations.Add('asciidoctor.asciidoctor-vscode')
	}
	if(Get-ChildItem -Recurse -Filter *.http |Select-Object -First 1)
	{
		[void]$recommendations.Add('humao.rest-client')
	}
	if(Get-ChildItem -Recurse -Filter *.ps1 |Select-Object -First 1)
	{
		[void]$recommendations.Add('ms-vscode.powershell')
	}
	if(Get-ChildItem -Recurse -Filter *.sql |Select-Object -First 1)
	{
		[void]$recommendations.Add('ms-mssql.mssql')
	}
	Set-VSCodeSetting.ps1 recommendations $recommendations -Workspace
}

function Add-DevContainerSettings
{
	if(Test-Path .devcontainer/devcontainer.json -Type Leaf)
	{
		${devcontainer.json} = '.devcontainer/devcontainer.json'
		$settings = Get-Content ${devcontainer.json} |ConvertFrom-Json
	}
	elseif(Test-Path .devcontainer.json -Type Leaf)
	{
		${devcontainer.json} = '.devcontainer.json'
		$settings = Get-Content ${devcontainer.json} |ConvertFrom-Json
	}
	else
	{
		${devcontainer.json} = '.devcontainer.json'
		$settings = [pscustomobject]@{
			customizations = [pscustomobject]@{
				vscode = [pscustomobject]@{
					settings=[pscustomobject]@{}
					extensions=@()
				}
			}
		}
	}
	if(!$settings.PSObject.Properties.Match('customizations').Count)
	{
		$settings |Add-Member -NotePropertyName customizations -NotePropertyValue ([pscustomobject]@{
			vscode = @{
				settings=[pscustomobject]@{}
				extensions=@()
			}
		})
	}
	elseif(!$settings.customizations.PSObject.Properties.Match('vscode').Count)
	{
		$settings.customizations |Add-Member -NotePropertyName vscode -NotePropertyValue ([pscustomobject]@{
			settings=[pscustomobject]@{}
			extensions=@()
		})
	}
	elseif(!$settings.customizations.vscode.PSObject.Properties.Match('extensions').Count)
	{
		$settings.customizations.vscode |Add-Member -NotePropertyName extensions -NotePropertyValue @()
	}
	$extensions = $settings.customizations.vscode.extensions -isnot [array] ?
		$settings.customizations.vscode.extensions : @()
	if(Get-ChildItem .github/workflows -Filter *.yml |Select-Object -First 1)
	{
		$extensions += 'GitHub.vscode-github-actions'
	}
	if(Get-ChildItem -Recurse -Filter *.md |Select-Object -First 1)
	{
		$extensions += 'DavidAnson.vscode-markdownlint'
	}
	if(Get-ChildItem -Recurse -Filter *.md |Select-String '```mermaid' |Select-Object -First 1)
	{
		$extensions += 'bierner.markdown-mermaid'
		$extensions += 'bpruitt-goddard.mermaid-markdown-syntax-highlighting'
	}
	if(Get-ChildItem -Recurse -Filter *.adoc |Select-Object -First 1)
	{
		$extensions += 'asciidoctor.asciidoctor-vscode'
	}
	$settings.customizations.vscode.extensions = @($extensions |Select-Object -Unique)
	$settings |ConvertTo-Json -Depth 5 |Out-File ${devcontainer.json} utf8
}

function Disable-VsCodePrettier
{
	if(!(Test-Path .vscode -PathType Container)) {mkdir .vscode |Out-Null}
	Set-VSCodeSetting.ps1 prettier.disableLanguages @('markdown') -Workspace
	Set-VSCodeSetting.ps1 '[markdown]' @{
		'editor.defaultFormatter' = 'yzhang.markdown-all-in-one'
	} -Workspace
}

function Add-Metadata
{
	Param(
	[string[]] $DefaultOwner,
	[hashtable] $Owners,
	[string[]] $VendorCode,
	[string[]] $DocumentationCode,
	[string[]] $GeneratedCode,
	[string] $IssueTemplate,
	[string] $PullRequestTemplate,
	[string] $ContributingFile,
	[string] $LicenseFile,
	[string] $DefaultCharset,
	[string] $DefaultLineEndings,
	[int] $DefaultIndentSize,
	[switch] $DefaultUsesTabs,
	[switch] $DefaultKeepTrailingSpace,
	[switch] $DefaultNoFinalNewLine,
	[switch] $NoWarnings,
	[switch] $Force
	)
	Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -choco git
	Push-Location $(git rev-parse --show-toplevel)
	Add-GitHubDirectory
	Add-Readme -NoWarnings:$NoWarnings
	if(!$NoOwners) {Add-CodeOwners -DefaultOwner $DefaultOwner -Owners $Owners -NoWarnings:$NoWarnings}
	Add-LinguistOverrides -VendorCode $VendorCode -DocumentationCode $DocumentationCode `
		-GeneratedCode $GeneratedCode -Force:$Force
	Add-IssueTemplate -IssueTemplate $IssueTemplate
	Add-PullRequestTemplate -PullRequestTemplate $PullRequestTemplate
	Add-ContributingGuidelines -ContributingFile $ContributingFile
	Add-License -LicenseFile $LicenseFile
	Add-EditorConfig -DefaultCharset $DefaultCharset -DefaultLineEndings $DefaultLineEndings `
		-DefaultIndentSize $DefaultIndentSize -DefaultUsesTabs:$DefaultUsesTabs `
		-DefaultKeepTrailingSpace:$DefaultKeepTrailingSpace -DefaultNoFinalNewLine:$DefaultNoFinalNewLine `
		-NoWarnings:$NoWarnings
	if($VsCodeExtensionRecommendations) {Add-VsCodeExtensionRecommendations}
	if($VSCodeDisablePrettierForMarkdown) {Disable-VsCodePrettier}
	if($DevContainer) {Add-DevContainerSettings}
	Pop-Location
}

Add-Metadata -DefaultOwner $DefaultOwner -Owners $Owners -VendorCode $VendorCode `
	-DocumentationCode $DocumentationCode -GeneratedCode $GeneratedCode -IssueTemplate $IssueTemplate `
	-PullRequestTemplate $PullRequestTemplate -ContributingFile $ContributingFile -LicenseFile $LicenseFile `
	-DefaultCharset $DefaultCharset -DefaultLineEndings $DefaultLineEndings -DefaultIndentSize $DefaultIndentSize `
	-DefaultUsesTabs:$DefaultUsesTabs -DefaultKeepTrailingSpace:$DefaultKeepTrailingSpace `
	-DefaultNoFinalNewLine:$DefaultNoFinalNewLine -NoWarnings:$NoWarnings -Force:$Force

