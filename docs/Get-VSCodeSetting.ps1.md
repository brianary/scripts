---
external help file: -help.xml
Module Name:
online version: https://code.visualstudio.com/docs/getstarted/settings
schema: 2.0.0
---

# Get-VSCodeSetting.ps1

## SYNOPSIS
Sets a VSCode setting.

## SYNTAX

```
Get-VSCodeSetting.ps1 [-JsonPointer] <String> [-Workspace] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-VSCodeSetting.ps1 gitlens.advanced.messages/suppressShowKeyBindingsNotice
```

True

### EXAMPLE 2
```
Get-VSCodeSetting.ps1 powershell.codeFormatting.preset -Workspace
```

Allman

### EXAMPLE 3
```
Get-VSCodeSetting.ps1 workbench.colorTheme -Workspace
```

PowerShell ISE

## PARAMETERS

### -JsonPointer
The full path name of the property to set, as a JSON Pointer, which separates each nested
element name with a /, and literal / is escaped as ~1, and literal ~ is escaped as ~0.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Workspace
Indicates that the current workspace settings should be

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

### System.String, System.Double, System.Int32, System.Boolean depending on VS Code JSON value type.
## NOTES

## RELATED LINKS

[https://code.visualstudio.com/docs/getstarted/settings](https://code.visualstudio.com/docs/getstarted/settings)

[Get-VSCodeSettingsFile.ps1]()

[ConvertFrom-Json]()

[Get-Content]()

