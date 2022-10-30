---
external help file: -help.xml
Module Name:
online version: https://getseq.net/
schema: 2.0.0
---

# Use-SeqServer.ps1

## SYNOPSIS
Set the default Server and ApiKey for Send-SeqEvent.ps1

## SYNTAX

```
Use-SeqServer.ps1 [-Server] <Uri> [[-ApiKey] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Use-SeqServer.ps1 http://my-seq $apikey
```

## PARAMETERS

### -Server
The URL of the Seq server.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 2
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

[https://getseq.net/](https://getseq.net/)

