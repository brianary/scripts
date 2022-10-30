---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Set-JsonProperty.ps1

## SYNOPSIS
Sets a property of arbitrary depth in a JSON string.

## SYNTAX

### InputObject
```
Set-JsonProperty.ps1 [-PropertyName] <String> [-PropertyValue] <PSObject> [-PathSeparator <Char>]
 [-WarnOverwrite] -InputObject <String> [<CommonParameters>]
```

### Path
```
Set-JsonProperty.ps1 [-PropertyName] <String> [-PropertyValue] <PSObject> [-PathSeparator <Char>]
 [-WarnOverwrite] -Path <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
'{a:1}' |Set-JsonProperty.ps1 b.ZZ\.ZZ.thing 7
```

{
	"a": 1,
	"b": {
			"ZZ.ZZ": {
				"thing": 7
			}
	}
}

## PARAMETERS

### -PropertyName
The full path name of the property to set.

With the default path separator of .
for a name of powershell.codeFormatting.preset sets
{ "powershell": { "codeFormatting": { "preset": "value" } } }
this can be escaped to powershell\.codeFormatting\.preset to set
{ "powershell.codeFormatting.preset": "value" }
Changing the path separator to / for a name of powershell.codeFormatting.preset also sets
{ "powershell.codeFormatting.preset": "value" }

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyValue
The value to set the property to.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: Value

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PathSeparator
The character to use as a property name path separator (dot by default).

With the default path separator of .
for a name of powershell.codeFormatting.preset sets
{ "powershell": { "codeFormatting": { "preset": "value" } } }
this can be escaped to powershell\.codeFormatting\.preset to set
{ "powershell.codeFormatting.preset": "value" }
Changing the path separator to / for a name of powershell.codeFormatting.preset also sets
{ "powershell.codeFormatting.preset": "value" }

```yaml
Type: Char
Parameter Sets: (All)
Aliases: Separator, Delimiter

Required: False
Position: Named
Default value: .
Accept pipeline input: False
Accept wildcard characters: False
```

### -WarnOverwrite
Indicates that overwriting values should generate a warning.

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

### -InputObject
The JSON string to set the property in.

```yaml
Type: String
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
A JSON file to update.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String containing JSON.
## OUTPUTS

### System.String containing updated JSON.
## NOTES

## RELATED LINKS

[ConvertFrom-Json]()

[ConvertTo-Json]()

[Add-Member]()

