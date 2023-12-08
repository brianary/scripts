---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Invoke-CommandWithParams.ps1

## SYNOPSIS
Execute a command by using matching dictionary entries as parameters.

## SYNTAX

```
Invoke-CommandWithParams.ps1 [-Name] <String> [-ParameterSet <String>] -Dictionary <IDictionary>
 [-ExcludeKeys <String[]>] [-OnlyMatches] [-IncludeCommon] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
@{Object="Hello, world!"} |Invoke-CommandWithParams.ps1 Write-Host
```

Hello, world!

### EXAMPLE 2
```
$PSBoundParameters |Invoke-CommandWithParams.ps1 Send-MailMessage -OnlyMatches
```

Uses any of the calling script's parameters matching those found in the Send-MailMessage param list to call the command.

## PARAMETERS

### -Name
The name of a command to run using the parameter dictionary.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CommandName

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParameterSet
The name of a parameter set defined by the cmdlet, to constrain to those parameters.

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

### -Dictionary
A dictionary of parameters to supply to the command.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases: Hashset

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ExcludeKeys
A list of dictionary keys to omit when sending dictionary parameters to the command.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Except

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlyMatches
Compares the keys in the parameter dictionary with the parameters supported by the command,
omitting any dictionary entries that do not map to known command parameters.
No checking for valid parameter sets is performed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Matching, 

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

### System.Collections.IDictionary, the parameters to supply to the command.
## OUTPUTS

## NOTES

## RELATED LINKS

[Select-DictionaryKeys.ps1]()

[ConvertTo-PowerShell.ps1]()

[Get-Command]()

