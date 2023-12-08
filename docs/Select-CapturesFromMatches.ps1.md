---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Select-CapturesFromMatches.ps1

## SYNOPSIS
Selects named capture group values as note properties from Select-String MatchInfo objects.

## SYNTAX

```
Select-CapturesFromMatches.ps1 [[-MatchInfo] <MatchInfo>] [-ValuesOnly] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
.*?\b)\s*(?<Email>\S+@\S+)$' addrbook.txt |Select-CapturesFromMatches.ps1
```

Name            Email
----            -----
Arthur Dent     adent@example.org
Tricia McMillan trillian@example.com

## PARAMETERS

### -MatchInfo
The MatchInfo output from Select-String to select named capture group values from.

```yaml
Type: MatchInfo
Parameter Sets: (All)
Aliases: InputObject

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ValuesOnly
Return the capture group values without building objects.

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

### Microsoft.PowerShell.Commands.MatchInfo, output from Select-String that used a pattern
### with named capture groups.
## OUTPUTS

### System.Management.Automation.PSObject containing selected capture group values.
## NOTES

## RELATED LINKS
