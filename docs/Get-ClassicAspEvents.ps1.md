---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-ClassicAspEvents.ps1

## SYNOPSIS
Gets Classic ASP errors from the event log on the given server.

## SYNTAX

```
Get-ClassicAspEvents.ps1 [[-ComputerName] <String[]>] [-EntryType <String[]>] [-After <DateTime>]
 [-Before <DateTime>] [-Newest <Int32>] [<CommonParameters>]
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

### -EntryType
Gets only events with the specified entry type.
Valid values are Error, Information, and Warning.
The default is all events.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -After
Skip events older than this datetime.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Before
Skip events newer than this datetime.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Newest
The maximum number of the most recent events to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Diagnostics.EventLogEntry of Classic ASP events.
## NOTES

## RELATED LINKS
