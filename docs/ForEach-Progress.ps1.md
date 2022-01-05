---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# ForEach-Progress.ps1

## SYNOPSIS
Performs an operation against each item in a collection of input objects, with a progress bar.

## SYNTAX

```
ForEach-Progress.ps1 [-Activity] <String> [[-Status] <ScriptBlock>] [[-Process] <ScriptBlock>]
 -InputObject <PSObject> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
1..10 |ForEach-Progress.ps1 -Activity 'Testing' {"$_"} {Write-Host "item: $_"; sleep 2}
```

## PARAMETERS

### -Activity
The progress title text to display.

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

### -Status
A script block to generate status text from each $PSItem ($_).

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Process
A script block to execute for each $PSItem ($_).

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
An item to process.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject to process.
## OUTPUTS

## NOTES

## RELATED LINKS
