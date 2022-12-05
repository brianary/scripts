---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# ConvertTo-PowerShell.ps1

## SYNOPSIS
Serializes complex content into PowerShell literals.

## SYNTAX

### GenerateKey (Default)
```
ConvertTo-PowerShell.ps1 [[-Value] <Object>] [-Indent <String>] [-IndentBy <String>] [-Newline <String>]
 [-SkipInitialIndent] [-Width <UInt16>] [-GenerateKey] [<CommonParameters>]
```

### SecureKey
```
ConvertTo-PowerShell.ps1 [[-Value] <Object>] [-Indent <String>] [-IndentBy <String>] [-Newline <String>]
 [-SkipInitialIndent] [-Width <UInt16>] -SecureKey <SecureString> [<CommonParameters>]
```

### Credential
```
ConvertTo-PowerShell.ps1 [[-Value] <Object>] [-Indent <String>] [-IndentBy <String>] [-Newline <String>]
 [-SkipInitialIndent] [-Width <UInt16>] -Credential <PSCredential> [<CommonParameters>]
```

### KeyBytes
```
ConvertTo-PowerShell.ps1 [[-Value] <Object>] [-Indent <String>] [-IndentBy <String>] [-Newline <String>]
 [-SkipInitialIndent] [-Width <UInt16>] -KeyBytes <Byte[]> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
4096LMB |ConvertTo-PowerShell.ps1
```

4LGB

### EXAMPLE 2
```
ConvertFrom-Json '[{"a":1,"b":2,"c":{"d":"\/Date(1490216371478)\/","e":null}}]' |ConvertTo-PowerShell.ps1
```

@(
		\[PSCustomObject\]@{
				a = 1
				b = 2
				c = \[PSCustomObject\]@{
								d = \[datetime\]'2017-03-22T20:59:31'
								e = $null
						}
		}
)

## PARAMETERS

### -Value
An array, hash, object, or value type that can be represented as a PowerShell literal.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Indent
The starting indent value.
You can probably ignore this.

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

### -IndentBy
The string to use for incremental indentation.

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

### -Newline
The line ending sequence to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [environment]::NewLine
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipInitialIndent
Indicates the first line has already been indented.
You can probably ignore this.

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

### -Width
The maximum width of string literals.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -GenerateKey
Generates a key to use for encrypting credential and secure string literals.
If this is omitted, credentials will be encrypted using DPAPI, which will only be
decryptable on the same Windows machine where they were encrypted.

```yaml
Type: SwitchParameter
Parameter Sets: GenerateKey
Aliases: PortableKey

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecureKey
The key to use for encrypting credentials and secure strings, as a secure string to be
encoded into UTF-8 bytes.

```yaml
Type: SecureString
Parameter Sets: SecureKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
A credential containing a password (the username is ignored) to be used for encrypting
credentials and secure strings, after encoding to UTF-8 bytes.

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyBytes
The key to use for encrypting credentials and secure strings, as a byte array.

```yaml
Type: Byte[]
Parameter Sets: KeyBytes
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

### System.Object (any object) to serialize.
## OUTPUTS

### System.String containing the object serialized to PowerShell literal statements.
## NOTES

## RELATED LINKS
