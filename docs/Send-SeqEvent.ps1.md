---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Send-SeqEvent.ps1

## SYNOPSIS
Send an event to a Seq server.

## SYNTAX

```
Send-SeqEvent.ps1 [[-Message] <String>] [-Properties] <Object> [-Level <String>] [-Server <Uri>]
 [-ApiKey <String>] [-LiteralMessage] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Send-SeqEvent.ps1 'Hello from PowerShell' -Server http://my-seq -LiteralMessage
```

### EXAMPLE 2
```
Send-SeqEvent.ps1 'Event: {User} on {Machine}' @{ User = $env:UserName; Machine = $env:ComputerName } -Server http://my-seq
```

### EXAMPLE 3
```
Send-SeqEvent.ps1 -Properties @{ Message = $Error[0].Exception.Message } -Level Error -Server http://my-seq
```

## PARAMETERS

### -Message
The text to use as the log message, a Seq template unless -LiteralMessage is present.
By default, the value of the Message property will be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Text

Required: False
Position: 1
Default value: {Message}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Logging properties to record in Seq, as an OrderedDictionary, Hashtable, DataRow,
or any object with properties to use.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Parameters

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Level
The type of event to record.
Information by default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Information
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
The URL of the Seq server.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
The Seq API key to use.

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

### -LiteralMessage
When present, indicates the Message parameter is to be used verbatim, not as a Seq template.

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

### System.Collections.Hashtable
### or System.Collections.Specialized.OrderedDictionary
### or System.Data.DataRow
### or an object
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Invoke-RestMethod]()

[https://getseq.net/](https://getseq.net/)

