---
external help file: -help.xml
Module Name:
online version: https://github.com/blog/2392-introducing-code-owners
schema: 2.0.0
---

# Add-GitHubMetadata.ps1

## SYNOPSIS
Adds GitHub Linguist overrides to a repo's .gitattributes.

## SYNTAX

```
Add-GitHubMetadata.ps1 [[-DefaultOwner] <String[]>] [[-Owners] <Hashtable>] [[-VendorCode] <String[]>]
 [[-DocumentationCode] <String[]>] [[-GeneratedCode] <String[]>] [[-IssueTemplate] <String>]
 [[-PullRequestTemplate] <String>] [[-ContributingFile] <String>] [[-LicenseFile] <String>]
 [[-DefaultCharset] <String>] [[-DefaultLineEndings] <String>] [[-DefaultIndentSize] <Int32>]
 [-DefaultUsesTabs] [-DefaultKeepTrailingSpace] [-DefaultNoFinalNewLine] [-NoWarnings]
 [-VsCodeExtensionRecommendations] [-VSCodeDisablePrettierForMarkdown] [-DevContainer] [-NoOwners] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Add-LinguistOverrides.ps1
```

## PARAMETERS

### -DefaultOwner
Sets the code owner(s) by @username or email address to use when no more specific
code owners are provided.
By default, any authors within a standard deviation of
the most commits will be included.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Owners
Maps .gitattribute-style globbing syntax for file matching to @username or email
address of owners of any matching files.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -VendorCode
A list of .gitattribute-style globbing syntax matches for files that should be
considered vendor code, for files not covered by the default behavior of
the default Linguist vendor code file glob patterns:
https://github.com/github/linguist/blob/master/lib/linguist/vendor.yml

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @('**/packages/**','**/lib/**')
Accept pipeline input: False
Accept wildcard characters: False
```

### -DocumentationCode
A list of .gitattribute-style globbing syntax matches for files that should be
considered documentation, for files not covered by the default behavior of
the default Linguist documentation file glob patterns:
https://github.com/github/linguist/blob/master/lib/linguist/documentation.yml

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GeneratedCode
A list of .gitattribute-style globbing syntax matches for files that should be
considered generated code, for files not covered by the default behavior of
the default Linguist generated code file glob patterns and contents matching:
https://github.com/github/linguist/blob/master/lib/linguist/generated.rb

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: @('"**/Service References/**"','"**/Web References/**"')
Accept pipeline input: False
Accept wildcard characters: False
```

### -IssueTemplate
A Markdown string containing a template for creating issues.
https://github.com/blog/2111-issue-and-pull-request-templates

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PullRequestTemplate
A Markdown string containing a template for creating pull requests.
https://github.com/blog/2111-issue-and-pull-request-templates

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContributingFile
The file path or URL containing guidelines for contributors in Markdown format.
https://help.github.com/articles/setting-guidelines-for-repository-contributors/

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LicenseFile
The file path or URL containing open source licensing for contributors in
Markdown format.
https://help.github.com/articles/adding-a-license-to-a-repository/

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultCharset
If no EditorConfig file exists, a simple default charset for text files in the
repo.
By default this is set to the system default, which is often terrible.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: $OutputEncoding.WebName
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultLineEndings
If no EditorConfig file exists, a simple default line endings value for text files
in the repo.
By default this is set to the system default, which is recommended.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: $(switch([Environment]::NewLine){"`n"{'lf'}"`r"{'cr'}default{'crlf'}})
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultIndentSize
If no EditorConfig file exists, a simple default number of characters to indent
lines for spaces (soft tabs) and tab display (hard tabs) for text files in the
repo.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: 4
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultUsesTabs
If no EditorConfig file exists, this switch indicates a simple default for text
files in the repo to use tabs.
Otherwise, spaces will be used for indentation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultKeepTrailingSpace
If no EditorConfig file exists, this switch indicates a simple default for text
files in the repo to preserve trailing spaces.
Otherwise, trailing spaces will
be trimmed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultNoFinalNewLine
If no EditorConfig file exists, this switch indicates a simple default for text
files in the repo not to add a final line ending at the end.
Otherwise, a final
line ending will be added automatically if it is missing.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoWarnings
Indicates warnings about new content should be skipped.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -VsCodeExtensionRecommendations
Configure VSCode settings to recommend relevant extensions based on repo content.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Recommendations

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -VSCodeDisablePrettierForMarkdown
Configure VSCode settings to disable the Prettier extension for Markdown files,
since Prettier's formatting settings are not configurable, and some break Markdown
for some interpreters (e.g. lower-casing footnote links is incompatible with GitHub Pages),
and some formatting choices may not be desirable or may conflict with organizational
standards.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: DisablePrettierMarkdown, NoPrettierMarkdown

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DevContainer
Configure settings for Dev Containers, used for Codespaces.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Codespaces

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoOwners
Disables adding or updating the CODEOWNERS file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Do not prompt to append Linguist settings.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[https://github.com/blog/2392-introducing-code-owners](https://github.com/blog/2392-introducing-code-owners)

[https://github.com/github/linguist#overrides](https://github.com/github/linguist#overrides)

[https://github.com/blog/2111-issue-and-pull-request-templates](https://github.com/blog/2111-issue-and-pull-request-templates)

[https://help.github.com/articles/setting-guidelines-for-repository-contributors/](https://help.github.com/articles/setting-guidelines-for-repository-contributors/)

[https://help.github.com/articles/adding-a-license-to-a-repository/](https://help.github.com/articles/adding-a-license-to-a-repository/)

[http://editorconfig.org/](http://editorconfig.org/)

[Add-CaptureToMatches.ps1]()

[Measure-StandardDeviation.ps1]()

[Test-FileTypeMagicNumber.ps1]()

[Remove-Utf8Signature.ps1]()

[Use-Command.ps1]()

