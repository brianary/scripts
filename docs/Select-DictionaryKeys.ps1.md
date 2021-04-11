---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/System.Collections.IDictionary.aspx
schema: 2.0.0
---

# Select-DictionaryKeys.ps1

## SYNOPSIS
Constructs an OrderedDictionary by selecting keys from a given IDictionary.

## SYNTAX

```
Select-DictionaryKeys.ps1 [[-Keys] <String[]>] -Dictionary <IDictionary> [-SkipNullValues] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
@{ A = 1; B = 2; C = 3 } |Select-DictionaryKeys.ps1 B D
```

Name Value
---- -----
B    2

### EXAMPLE 2
```
$PSBoundParameters |Select-DictionaryKeys.ps1 From To Cc Bcc Subject -SkipNullValues |Send-MailMessage
```

Sends an email using selected params declared by the calling script with values.

## PARAMETERS

### -Keys
List of keys to include in the new dictionary.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Dictionary
The source dictionary to copy key-value pairs from.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases: Hashtable

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SkipNullValues
When present, indicates that key-value pairs with a null value should not be included.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: NoNulls

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Collections.IDictionary, the source dictionary to select key-value pairs from by key.
## OUTPUTS

### System.Collections.Specialized.OrderedDictionary, the dictionary matching key-value pairs are copied to.
## NOTES
Only string keys are supported.

## RELATED LINKS

[https://msdn.microsoft.com/library/System.Collections.IDictionary.aspx](https://msdn.microsoft.com/library/System.Collections.IDictionary.aspx)

