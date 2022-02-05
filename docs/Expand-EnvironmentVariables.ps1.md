---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.environment.expandenvironmentvariables
schema: 2.0.0
---

# Expand-EnvironmentVariables.ps1

## SYNOPSIS
Replaces the name of each environment variable embedded in the specified string with the string equivalent of the value of the variable, then returns the resulting string.

## SYNTAX

```
Expand-EnvironmentVariables.ps1 [-Value] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Expand-EnvironmentVariables.ps1 %SystemRoot%\System32\cmd.exe
```

C:\WINDOWS\System32\cmd.exe

## PARAMETERS

### -Value
{{ Fill Value Description }}

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

[https://docs.microsoft.com/dotnet/api/system.environment.expandenvironmentvariables](https://docs.microsoft.com/dotnet/api/system.environment.expandenvironmentvariables)

