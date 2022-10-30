---
external help file: -help.xml
Module Name:
online version: http://en.wikipedia.org/wiki/Binary_prefix
schema: 2.0.0
---

# Format-ByteUnits.ps1

## SYNOPSIS
Converts bytes to largest possible units, to improve readability.

## SYNTAX

```
Format-ByteUnits.ps1 [-Bytes] <BigInteger> [-Precision <Byte>] [-UseSI] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Format-ByteUnits 65536
64KB
```

### EXAMPLE 2
```
Format-ByteUnits 9685059 -dot 1 -si
9.2 MiB
```

### EXAMPLE 3
```
ls *.log |measure -sum Length |select -exp Sum |Format-ByteUnits -dot 2 -si
302.39 MiB
```

## PARAMETERS

### -Bytes
The number of bytes to express in larger units.

```yaml
Type: BigInteger
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Precision
The maximum number of digits after the decimal to keep.
The default is 16 (the maximum).

```yaml
Type: Byte
Parameter Sets: (All)
Aliases: Digits, dot

Required: False
Position: Named
Default value: 16
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSI
Displays unambiguous SI units (with a space).
By default, native PowerShell units are used
(without a space, to allow round-tripping the value,
though there may be significant rounding loss depending on precision).

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: si

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Numerics.BigInteger representing a number of bytes.
## OUTPUTS

### System.String containing the number of bytes scaled to fit the appropriate units.
## NOTES

## RELATED LINKS

[http://en.wikipedia.org/wiki/Binary_prefix](http://en.wikipedia.org/wiki/Binary_prefix)

[http://physics.nist.gov/cuu/Units/binary.html](http://physics.nist.gov/cuu/Units/binary.html)

