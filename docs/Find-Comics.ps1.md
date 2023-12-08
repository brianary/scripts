---
external help file: -help.xml
Module Name:
online version: https://api.shortboxed.com/
schema: 2.0.0
---

# Find-Comics.ps1

## SYNOPSIS
Finds comics.

## SYNTAX

### Title
```
Find-Comics.ps1 -Title <String[]> [-ReleaseWeek <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Creator
```
Find-Comics.ps1 -Creator <String[]> [-ReleaseWeek <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### TitleMatch
```
Find-Comics.ps1 -TitleMatch <Regex> [-ReleaseWeek <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### CreatorMatch
```
Find-Comics.ps1 -CreatorMatch <Regex> [-ReleaseWeek <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Condition
```
Find-Comics.ps1 [-Condition] <ScriptBlock> [-ReleaseWeek <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-Comics.ps1 -Creator 'Grant Morrison','Matt Fraction','David Aja','Kyle Higgins' |Format-Table publisher,title,creators
```

publisher         title                                creators
---------         -----                                --------
BOOM!
STUDIOS     KLAUS HC LIFE & TIMES OF SANTA CLAUS (W) Grant Morrison (A/CA) Dan Mora
DARK HORSE COMICS SEEDS TP                             (W) Ann Nocenti (A/CA) David Aja
MARVEL COMICS     MARVEL-VERSE GN-TP WANDA & VISION    (W) Kyle Higgins, More (A) Stephane Perger, More (CA) Daniel Acuna, Jim Cheung

## PARAMETERS

### -Title
Text to search titles.
Comics with titles containing this text will be returned.

```yaml
Type: String[]
Parameter Sets: Title
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Creator
Text to search creators.
Comics with creators containing this text will be returned.

```yaml
Type: String[]
Parameter Sets: Creator
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TitleMatch
A regular exression to match titles.
Comics with matching titles will be returned.

```yaml
Type: Regex
Parameter Sets: TitleMatch
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatorMatch
A regular expression to search the list of creators for.
Comics with a matching list of creators will be returned.
The regex will match against a complete list of creators, so anchor with word breaks (\b)
rather than the beginning or end of the string (^ or $ or \A or \z).

e.g.
(W) Jason Aaron (A/CA) Russell Dauterman

W = writer
A = artist
CA = color artist

```yaml
Type: Regex
Parameter Sets: CreatorMatch
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Condition
A filtering script block with the comic as the PSItem ($_) that evaluates to true to
return the comic.

```yaml
Type: ScriptBlock
Parameter Sets: Condition
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReleaseWeek
Specifies which week (relative to the current week) to return comics for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Upcoming
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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

## NOTES

## RELATED LINKS

[https://api.shortboxed.com/](https://api.shortboxed.com/)

[Get-Comics.ps1]()

