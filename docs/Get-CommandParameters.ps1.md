---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-CommandParameters.ps1

## SYNOPSIS
Returns the parameters of the specified cmdlet.

## SYNTAX

```
Get-CommandParameters.ps1 [-CommandName] <String> [-ParameterSet <String>] [-NamesOnly] [-IncludeCommon]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-CommandParameters.ps1 Write-Verbose
```

Name            : Message
ParameterType   : System.String
ParameterSets   : {\[__AllParameterSets, System.Management.Automation.ParameterSetMetadata\]}
IsDynamic       : False
Aliases         : {Msg}
Attributes      : {, System.Management.Automation.AllowEmptyStringAttribute, System.Management.Automation.AliasAttribute}
SwitchParameter : False

### EXAMPLE 2
```
Get-CommandParameters.ps1 Out-Default -NamesOnly
```

Transcript
InputObject

## PARAMETERS

### -CommandName
The name of a cmdlet.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParameterSet
The name of a parameter set defined by the cmdlet.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NamesOnly
Return only the parameter names (otherwise)

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

### -IncludeCommon
Includes common parameters such as -Verbose and -WhatIf.

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

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS

[Stop-ThrowError.ps1]()

[Get-Command]()

