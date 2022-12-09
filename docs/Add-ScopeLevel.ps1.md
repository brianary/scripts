---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Add-ScopeLevel.ps1

## SYNOPSIS
Convert a scope level to account for another call stack level.

## SYNTAX

```
Add-ScopeLevel.ps1 [-Scope] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Add-ScopeLevel.ps1 Local
```

1

### EXAMPLE 2
```
Add-ScopeLevel.ps1 3
```

4

### EXAMPLE 3
```
Add-ScopeLevel.ps1 Global
```

Global

## PARAMETERS

### -Scope
The requested scope from the caller of the caller of this script.

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

[Stop-ThrowError.ps1]()

[Get-PSCallStack]()

