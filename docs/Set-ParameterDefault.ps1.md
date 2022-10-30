---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Set-ParameterDefault.ps1

## SYNOPSIS
Assigns a value to use for the specified cmdlet parameter to use when one is not specified.

## SYNTAX

```
Set-ParameterDefault.ps1 [-CommandName] <String> [-ParameterName] <String> [-Value] <Object> [-Scope <String>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Set-ParameterDefault.ps1 epcsv nti $true -Scope Global
```

Establishes that the -NoTypeInformation param of the Export-Csv cmdlet will be true if not otherwise specified,
globally for the PowerShell session.

### EXAMPLE 2
```
Set-ParameterDefault.ps1 Select-Xml Namespace @{svg = 'http://www.w3.org/2000/svg'}
```

Uses only the SVG namespace for Select-Xml when none are given explicitly.

## PARAMETERS

### -CommandName
The name of a cmdlet, function, script, or alias to assign a default parameter value to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CmdletName

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParameterName
The name or alias of the parameter to assign a default value to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
The value to assign as a default.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Scope
The scope of this default.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object containing the default value to assign.
## OUTPUTS

## NOTES

## RELATED LINKS

[Add-ScopeLevel.ps1]()

[Stop-ThrowError.ps1]()

[Get-Command]()

[about_Scopes]()

