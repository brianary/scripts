---
external help file: -help.xml
Module Name:
online version: https://api.shortboxed.com/
schema: 2.0.0
---

# Get-Comics.ps1

## SYNOPSIS
Returns a cached list of comics from the Shortboxed API.

## SYNTAX

```
Get-Comics.ps1 [[-ReleaseWeek] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -ReleaseWeek
Specifies which week (relative to the current week) to return comics for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Upcoming
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

### System.Management.Automation.PSObject[]
## NOTES

## RELATED LINKS

[https://api.shortboxed.com/](https://api.shortboxed.com/)

[Invoke-WebRequest]()

[ConvertFrom-Json]()

[Get-Date]()

