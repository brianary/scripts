---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Update-Everything.ps1

## SYNOPSIS
Updates all packages it can.

## SYNTAX

```
Update-Everything.ps1 [[-Steps] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Steps
The sources of updates to install, in order.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: @('Essentials','WindowsStore','Scoop','Chocolatey','WinGet','Npm','Dotnet',
		'PSModules','PSHelp','DellCommand','Windows')
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
