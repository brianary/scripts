---
external help file: -help.xml
Module Name:
online version: http://webcoder.info/recurrence.html
schema: 2.0.0
---

# ConvertTo-ICalendar.ps1

## SYNOPSIS
Converts supported objects to the RFC 5545 iCalendar format.

## SYNTAX

```
ConvertTo-ICalendar.ps1 [-ScheduledTask] <CimInstance> [[-TimeZone] <TimeZoneInfo>]
 [[-DefaultTaskDuration] <TimeSpan>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ScheduledTask -TaskPath \ |ConvertTo-ICalendar.ps1 |Out-File tasks.ical utf8
```

## PARAMETERS

### -ScheduledTask
A CimInstance of MSFT_ScheduledTask, as output by Get-ScheduledTask.

```yaml
Type: CimInstance
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -TimeZone
The time zone to use in the iCalendar data.

```yaml
Type: TimeZoneInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Get-TimeZone |ForEach-Object {[string]$tzid = 'UTC'
	[void][TimeZoneInfo]::TryConvertWindowsIdToIanaId($_.Id, [ref]$tzid); Get-TimeZone -Id $tzid})
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultTaskDuration
For tasks without an explicit duration, use this as the duration in the iCalendar events.

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 00:01:00
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.Management.Infrastructure.CimInstance of CIM class MSFT_ScheduledTask, as
### returned by Get-ScheduledTask.
## OUTPUTS

### System.String containing iCalendar data.
## NOTES
This is still a work in progress.

## RELATED LINKS

[http://webcoder.info/recurrence.html](http://webcoder.info/recurrence.html)

[https://datatracker.ietf.org/doc/html/rfc5545](https://datatracker.ietf.org/doc/html/rfc5545)

[https://wutils.com/wmi/root/microsoft/windows/taskscheduler/msft_scheduledtask/](https://wutils.com/wmi/root/microsoft/windows/taskscheduler/msft_scheduledtask/)

[https://docs.microsoft.com/windows-server/administration/windows-commands/schtasks-query](https://docs.microsoft.com/windows-server/administration/windows-commands/schtasks-query)

[https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/cc725744%28v=ws.11%29](https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/cc725744%28v=ws.11%29)

[Use-Command.ps1]()

[ConvertFrom-CimInstance.ps1]()

[ConvertFrom-XmlElement.ps1]()

[New-ScheduledTaskTrigger]()

[Get-Date]()

