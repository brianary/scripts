---
external help file: -help.xml
Module Name:
online version: https://code.visualstudio.com/docs/getstarted/settings
schema: 2.0.0
---

# Get-VSCodeSettingsFile.ps1

## SYNOPSIS
Gets the path of the VSCode settings.config file.

## SYNTAX

```
Get-VSCodeSettingsFile.ps1 [-Workspace] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-VSCodeSettingsFile.ps1
```

C:\Users\zaphodb\AppData\Roaming\Code\User\settings.json

### EXAMPLE 2
```
Get-VSCodeSettingsFile.ps1 -Workspace
```

C:\Users\zaphodb\GitHub\scripts\.vscode\settings.json

## PARAMETERS

### -Workspace
Indicates that the current workspace settings should be parsed instead of the user settings.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String containing the path of the settings.config file.
## NOTES

## RELATED LINKS

[https://code.visualstudio.com/docs/getstarted/settings](https://code.visualstudio.com/docs/getstarted/settings)

[https://powershell.github.io/PowerShellEditorServices/api/Microsoft.PowerShell.EditorServices.Extensions.EditorObject.html](https://powershell.github.io/PowerShellEditorServices/api/Microsoft.PowerShell.EditorServices.Extensions.EditorObject.html)

[https://git-scm.com/docs/git-rev-parse](https://git-scm.com/docs/git-rev-parse)

[Join-Path]()

[Get-Command]()

[Stop-ThrowError.ps1]()

