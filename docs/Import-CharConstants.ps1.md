---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Import-CharConstants.ps1

## SYNOPSIS
Imports characters by name as constants into the current scope.

## SYNTAX

```
Import-CharConstants.ps1 [-CharacterName] <String[]> [-Scope <String>] [-AsEmoji]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Import-CharConstants.ps1 NL :UP: HYPHEN-MINUS 'EN DASH' '&mdash;' '&copy;' -Scope Script
```

Creates constants in the context of the current script for the named characters.

## PARAMETERS

### -CharacterName
The control code abbreviation, Unicode name, HTML entity, or GitHub name of the character to create a constant for.
"NL" will use the newline appropriate to the environment.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Scope
The scope of the constant.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Local
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsEmoji
Appends a U+FE0F VARIATION SELECTOR-16 suffix to the character, which suggests an emoji presentation
for characters that support both a simple text presentation as well as a color emoji-style one.

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

### System.String containing a character name.
## OUTPUTS

## NOTES

## RELATED LINKS

[Add-ScopeLevel.ps1]()

[Get-UnicodeByName.ps1]()

