---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Rename-Script.ps1

## SYNOPSIS
Renames all instances of a script, and updates any usage of it.

## SYNTAX

```
Rename-Script.ps1 [-OldName] <String> [-NewName] <String> [[-ScriptDirectory] <String[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Rename-Script.ps1 Get-RomanNumeral.ps1 ConvertTo-RomanNumeral.ps1
```

Renames the script file, and searches other script files for references to it,
and updates them.

## PARAMETERS

### -OldName
The current name of the script to change.

```yaml
Type: String
Parameter Sets: (All)
Aliases: From

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
The desired name of the script to change to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: To

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptDirectory
Any directories within which to rename the script (and any usage).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Directory

Required: False
Position: 3
Default value: .
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

## NOTES

## RELATED LINKS

[Set-RegexReplace.ps1]()

