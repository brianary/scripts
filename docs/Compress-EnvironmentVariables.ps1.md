---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Compress-EnvironmentVariables.ps1

## SYNOPSIS
Replaces each of the longest matching parts of a string with an embedded environment variable with that value.

## SYNTAX

```
Compress-EnvironmentVariables.ps1 [-Value] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Compress-EnvironmentVariables.ps1 'C:\Program Files\Git\bin\git.exe'
```

%ProgramFiles%\Git\bin\git.exe

## PARAMETERS

### -Value
The string to generalize with environment variable substitution.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
