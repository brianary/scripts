---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-AspNetEvents.ps1

## SYNOPSIS
Parses ASP.NET errors from the event log on the given server.

## SYNTAX

```
Get-AspNetEvents.ps1 [[-ComputerName] <String[]>] [[-After] <DateTime>] [[-Before] <DateTime>] [-AllProperties]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-AspNetEvents.ps1 WebServer
```

Returns any ASP.NET-related events from the WebServer Application event log that occurred today.

## PARAMETERS

### -ComputerName
The name of the server on which the error occurred.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN, Server

Required: False
Position: 1
Default value: $env:COMPUTERNAME
Accept pipeline input: False
Accept wildcard characters: False
```

### -After
Skip events older than this datetime.
Defaults to 00:00 today.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: ([DateTime]::Today)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Before
Skip events newer than this datetime.
Defaults to now.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: ([DateTime]::Now)
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllProperties
{{ Fill AllProperties Description }}

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

### System.Management.Automation.PSObject containing the fields stored in the event.
## NOTES

## RELATED LINKS

[Get-WinEvent]()

