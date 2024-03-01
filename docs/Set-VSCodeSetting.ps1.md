---
external help file: -help.xml
Module Name:
online version: https://code.visualstudio.com/docs/getstarted/settings
schema: 2.0.0
---

# Set-VSCodeSetting.ps1

## SYNOPSIS
Sets a VSCode setting.

## SYNTAX

```
Set-VSCodeSetting.ps1 [-JsonPointer] <String> [-Value] <PSObject> [-Workspace]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Set-VSCodeSetting.ps1 git.autofetch $true -Workspace
```

Sets {"git.autofetch": true} in the VSCode user settings.

### EXAMPLE 2
```
Set-VSCodeSetting.ps1 powershell.codeFormatting.preset Allman -Workspace
```

Sets {"powershell.codeFormatting.preset": "Allman"} in the VSCode workspace settings.

### EXAMPLE 3
```
Set-VSCodeSetting.ps1 workbench.colorTheme 'PowerShell ISE' -Workspace
```

Sets {"workbench.colorTheme": "PowerShell ISE"} in the VSCode workspace settings.

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

### -Value
The value of the setting to set.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Workspace
Indicates that the current workspace settings should be set, rather than the user settings.

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

### System.Void
## NOTES

## RELATED LINKS

[https://code.visualstudio.com/docs/getstarted/settings](https://code.visualstudio.com/docs/getstarted/settings)

[Get-VSCodeSettingsFile.ps1]()

[Set-JsonProperty.ps1]()

