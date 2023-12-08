---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Send-SeqScriptEvent.ps1

## SYNOPSIS
Sends an event (often an error) from a script to a Seq server, including script info.

## SYNTAX

```
Send-SeqScriptEvent.ps1 [-Action] <String> [[-ErrorRecord] <ErrorRecord>] [[-Level] <String>]
 [-InvocationScope <String>] [-Server <Uri>] [-ApiKey <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
try { Connect-Thing } catch { Send-SeqScriptEvent.ps1 'Trying to connect' $_ -Level Error -Server http://my-seq }
```

## PARAMETERS

### -Action
A description of what was being attempted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorRecord
An optional PowerShell ErrorRecord object to record.
Will try to automatically find $_ in a calling "catch{}"" block.

```yaml
Type: ErrorRecord
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: ((Get-Variable _ -Scope 1 -ValueOnly -EA SilentlyContinue) -as [Management.Automation.ErrorRecord])
Accept pipeline input: False
Accept wildcard characters: False
```

### -Level
The type of event to record.
Defaults to Error if an ErrorRecord is found, Information otherwise.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Error
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvocationScope
The scope of the script InvocationInfo to use.
Defaults to 1 (the script calling Send-SeqScriptEvent.ps1).
Sending a 2 will try to use the script calling the script calling this one.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Scope

Required: False
Position: Named
Default value: 1
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

[Send-SeqEvent.ps1]()

[https://getseq.net/](https://getseq.net/)

