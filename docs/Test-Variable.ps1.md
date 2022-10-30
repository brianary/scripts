---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-Variable.ps1

## SYNOPSIS
Indicates whether a variable has been defined.

## SYNTAX

```
Test-Variable.ps1 [-Name] <String> [[-Scope] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-Variable.ps1 true
```

True

### EXAMPLE 2
```
Test-Variable.ps1 ''
```

False

A variable can't have an empty string for a name.

### EXAMPLE 3
```
Test-Variable.ps1 $null
```

False

A variable can't have a null name.

### EXAMPLE 4
```
Test-Variable.ps1 null
```

True

### EXAMPLE 5
```
'PSVersionTable','false' |Test-Variable.ps1
```

True
True

### EXAMPLE 6
```
'PWD','PID' |Test-Variable.ps1 -Scope Global
```

True
True

## PARAMETERS

### -Name
A variable name to test the existence of.

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

### -Scope
{{ Fill Scope Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String name of a variable.
## OUTPUTS

### System.Boolean indicating whether the variable name is defined.
## NOTES

## RELATED LINKS

[Add-ScopeLevel.ps1]()

[Get-Variable]()

