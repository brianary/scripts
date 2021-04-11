---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Add-CapturesToMatches.ps1

## SYNOPSIS
Adds named capture groups as note properties to Select-String's MatchInfo objects.

## SYNTAX

```
Add-CapturesToMatches.ps1 [[-MatchInfo] <MatchInfo>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
.*?\b)\s*(?<Email>\S+@\S+)$' addrbook.txt |Add-CapturesToMatches.ps1 |select Name,Phone,Filename
```

Name            Email                Filename
----            -----                --------
Arthur Dent     adent@example.org    addrbook.txt
Tricia McMillan trillian@example.com addrbook.txt

## PARAMETERS

### -MatchInfo
The MatchInfo output from Select-String to augment with named capture groups.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.PowerShell.Commands.MatchInfo, output from Select-String that used a pattern
### with named capture groups.
## OUTPUTS

### Microsoft.PowerShell.Commands.MatchInfo with additional note properties for each named
### capture group.
## NOTES

## RELATED LINKS

[Add-Member]()

