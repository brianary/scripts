---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Add-DynamicParam.ps1

## SYNOPSIS
Adds a dynamic parameter to a script, within a DynamicParam block.

## SYNTAX

```
Add-DynamicParam.ps1 [-Name] <String> [[-Type] <Type>] [-Position <Int32>] [-ParameterSetName <String[]>]
 [-Alias <String[]>] [-ValidateCount <Int32[]>] [-ValidateDrive <String[]>] [-ValidateLength <Int32[]>]
 [-ValidatePattern <String>] [-ValidateRange <Int32[]>] [-ValidateScript <ScriptBlock>]
 [-ValidateSet <Object[]>] [-NotNull] [-NotNullOrEmpty] [-TrustedData] [-UserDrive] [-Mandatory]
 [-ValueFromPipeline] [-ValueFromPipelineByPropertyName] [-ValueFromRemainingArguments] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
DynamicParam { Add-DynamicParam.ps1 Path string -Mandatory; $DynamicParams } Process { Import-Variables.ps1 $PSBoundParameters; ... }
```

## PARAMETERS

### -Name
The name of the parameter.

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

### -Type
The data type of the parameter.

```yaml
Type: Type
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Position
The position of the parameter when not specifying the parameter names.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: -2147483648
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParameterSetName
The name of the set of parameters this parameter belongs to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: __AllParameterSets
Accept pipeline input: False
Accept wildcard characters: False
```

### -Alias
{{ Fill Alias Description }}

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

### -ValidateCount
The valid number of values for a parameter that accepts a collection.
A range can be specified with a list of two integers.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: Count

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateDrive
Valid root drive(s) for parameters that accept paths.

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

### -ValidateLength
The valid length for a string parameter.
A range can be specified with a list of two integers.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: Length

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidatePattern
The valid regular expression pattern to match for a string parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Match, Pattern

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateRange
The valid range of values for a numeric parameter.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: Range

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateScript
A script block to validate a parameter's value.
Any true result will validate the value, any false result will reject it.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateSet
A set of valid values for the parameter.
This will enable tab-completion.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: Values

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NotNull
Requires parameter to be non-null.

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

### -NotNullOrEmpty
Requires parameter to be non-null and non-empty.

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

### -TrustedData
Requires the parameter value to be Trusted data.

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

### -UserDrive
Requires a path parameter to be on a User drive.

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

### -Mandatory
Indicates a required parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Required

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValueFromPipeline
Indicates a parameter that can accept values from the pipeline.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Pipeline

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValueFromPipelineByPropertyName
Indicates a parameter that can accept values from the pipeline by matching the property name of pipeline objects to the
parameter name or alias.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: PipelineProperties, PipeName

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValueFromRemainingArguments
{{ Fill ValueFromRemainingArguments Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: RemainingArgs

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object[] a list of possible values for this parameter to validate against.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS
