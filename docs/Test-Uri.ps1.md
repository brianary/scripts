---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-Uri.ps1

## SYNOPSIS
Determines whether a string is a valid URI.

## SYNTAX

```
Test-Uri.ps1 [-InputObject] <String> [[-UriKind] <UriKind>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-Uri.ps1 http://example.org
```

True

### EXAMPLE 2
```
Test-Uri.ps1 0
```

False

## PARAMETERS

### -InputObject
The string to test.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UriKind
What kind of URI to test for: Absolute, Relative, or RelativeOrAbsolute.

```yaml
Type: UriKind
Parameter Sets: (All)
Aliases:
Accepted values: RelativeOrAbsolute, Absolute, Relative

Required: False
Position: 2
Default value: Absolute
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

### System.String value to test for a valid URI format.
## OUTPUTS

### System.Boolean indicating that the string can be parsed as a URI.
## NOTES

## RELATED LINKS
