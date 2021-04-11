---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/system.management.automation.host.pshostuserinterface.promptforchoice.aspx
schema: 2.0.0
---

# Read-Choice.ps1

## SYNOPSIS
Returns choice selected from a list of options.

## SYNTAX

### ChoicesArray
```
Read-Choice.ps1 [-Choices] <String[]> [-Caption <String>] [-Message <String>] [-DefaultIndex <Int32>]
 [<CommonParameters>]
```

### ChoicesHash
```
Read-Choice.ps1 [-ChoiceHash] <IDictionary> [-Caption <String>] [-Message <String>] [-DefaultIndex <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Read-Choice.ps1 one,two,three
```

Please select:
\[\] one  \[\] two  \[\] three  \[?\] Help (default is "one"):
one

### EXAMPLE 2
```
Read-Choice.ps1 ([ordered]@{'&one'='first thing';'&two'='second thing';'t&hree'='third thing'}) -Message 'Pick:'
```

Pick:
\[O\] one  \[T\] two  \[H\] three  \[?\] Help (default is "O"): ?
O - first thing
T - second thing
H - third thing
\[O\] one  \[T\] two  \[H\] three  \[?\] Help (default is "O"):
&one

## PARAMETERS

### -Choices
A list of choice strings.
Use & in front of a letter to make it a hotkey.

```yaml
Type: String[]
Parameter Sets: ChoicesArray
Aliases: Options

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ChoiceHash
An ordered hash of choices mapped to help text descriptions.
Use & in front of a letter to make it a hotkey.

```yaml
Type: IDictionary
Parameter Sets: ChoicesHash
Aliases: Menu

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Caption
A title to use for the prompt.

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

### -Message
Instructional text to provide in the prompt.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Please select:
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultIndex
The index of the default choice.
Use -1 to for no default.
Otherwise, the first item (index 0) is the default.

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

### System.String containing a choice to offer.
## OUTPUTS

### System.String containing the choice that was selected.
## NOTES

## RELATED LINKS

[https://msdn.microsoft.com/library/system.management.automation.host.pshostuserinterface.promptforchoice.aspx](https://msdn.microsoft.com/library/system.management.automation.host.pshostuserinterface.promptforchoice.aspx)

