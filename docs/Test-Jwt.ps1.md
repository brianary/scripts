---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-Jwt.ps1

## SYNOPSIS
Determines whether a string is a valid JWT.

## SYNTAX

```
Test-Jwt.ps1 [-InputObject] <String> [-Secret] <SecureString> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-Jwt.ps1 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOjE1MTYyMzkwMjIsInN1YiI6IjEyMzQ1Njc4OTAifQ.-zAn1et1mf6QHakJbOTt5-p4gv33R7cIikKy8-9aiNs' (ConvertTo-SecureString swordfish -AsPlainText -Force)
```

True

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

### -Secret
The secret used to sign the JWT.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
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
