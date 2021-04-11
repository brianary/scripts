---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-Lines.ps1

## SYNOPSIS
Searches a specific subset of files for lines matching a pattern.

## SYNTAX

### Default (Default)
```
Find-Lines.ps1 [-Pattern] <String[]> [[-Filters] <String[]>] [[-Path] <String[]>] [-Include <String[]>]
 [-Exclude <String[]>] [-CaseSensitive] [-List] [-NotMatch] [-SimpleMatch] [-NoRecurse] [-ChooseMatches]
 [<CommonParameters>]
```

### Open
```
Find-Lines.ps1 [-Pattern] <String[]> [[-Filters] <String[]>] [[-Path] <String[]>] [-Include <String[]>]
 [-Exclude <String[]>] [-CaseSensitive] [-List] [-NotMatch] [-SimpleMatch] [-NoRecurse] [-ChooseMatches]
 [-Open] [<CommonParameters>]
```

### Blame
```
Find-Lines.ps1 [-Pattern] <String[]> [[-Filters] <String[]>] [[-Path] <String[]>] [-Include <String[]>]
 [-Exclude <String[]>] [-CaseSensitive] [-List] [-NotMatch] [-SimpleMatch] [-NoRecurse] [-ChooseMatches]
 [-Blame] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-Lines 'using System;' *.cs "$env:USERPROFILE\Documents\Visual Studio*\Projects" -CaseSensitive -List
```

This command searches all of the .cs files in the Projects directory (or directories) and subdirectories,
returning the matches.

## PARAMETERS

### -Pattern
Specifies the text to find.
Type a string or regular expression.
If you type a string, use the SimpleMatch parameter.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filters
Specifies wildcard filters that file names must match.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies a path to one or more locations.
Wildcards are permitted.
The default location is the current directory (.).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Include
Wildcard patterns files must match one of (slower than Filter).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
Wildcard patterns files must not match any of.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @('*.dll','*.exe','*.pdb','*.bin','*.cache','*.png','*.gif','*.jpg','*.ico','*.psd','*.obj','*.iso',
	'*.docx','*.xls','*.xlsx','*.pdf','*.rtf','*.swf','*.chm','*.ttf','*.woff','*.eot','*.otf','*.mdf','*.ldf','*.pack',
	'*.zip','*.gz','*.tgz','*.jar','*.nupkg','*.vspscc','*.vsmdi','*.vssscc','*.vsd','*.vscontent','*.vssettings','*.suo',
	'*.dbmdl','*.tdf','*.optdata','*.sigdata','*.lib')
Accept pipeline input: False
Accept wildcard characters: False
```

### -CaseSensitive
Makes matches case-sensitive.
By default, matches are not case-sensitive.

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

### -List
Returns only the first match in each input file.
By default, Select-String returns a MatchInfo object for each match it finds.

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

### -NotMatch
Finds text that does not match the specified pattern.

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

### -SimpleMatch
Uses a simple match rather than a regular expression match.
In a simple match, Select-String searches the input for the text in the Pattern parameter.
It does not interpret the value of the Pattern parameter as a regular expression statement.

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

### -NoRecurse
Disables searching subdirectories.

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

### -ChooseMatches
Displays a grid of matches to select a subset from.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Pick

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Open
Invokes files that contain matches.

```yaml
Type: SwitchParameter
Parameter Sets: Open
Aliases: View

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Blame
Returns git blame info for matching lines.

```yaml
Type: SwitchParameter
Parameter Sets: Blame
Aliases: Who

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Microsoft.PowerShell.Commands.MatchInfo with each match found.
## NOTES

## RELATED LINKS
