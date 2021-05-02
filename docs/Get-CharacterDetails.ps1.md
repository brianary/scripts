---
external help file: -help.xml
Module Name:
online version: http://unicode.org/
schema: 2.0.0
---

# Get-CharacterDetails.ps1

## SYNOPSIS
Returns filterable categorical information about characters in the Unicode Basic Multilingual Plane.

## SYNTAX

### Block
```
Get-CharacterDetails.ps1 [[-Block] <String>] [-IsControl] [-NotControl] [-IsDigit] [-NotDigit]
 [-IsHighSurrogate] [-NotHighSurrogate] [-IsLegalUserName] [-NotLegalUserName] [-IsLegalFileName]
 [-NotLegalFileName] [-IsLetter] [-NotLetter] [-IsLetterOrDigit] [-NotLetterOrDigit] [-IsLower] [-NotLower]
 [-IsLowSurrogate] [-NotLowSurrogate] [-IsMark] [-NotMark] [-IsNumber] [-NotNumber] [-IsPunctuation]
 [-NotPunctuation] [-IsSeparator] [-NotSeparator] [-IsSurrogate] [-NotSurrogate] [-IsSymbol] [-NotSymbol]
 [-IsUpper] [-NotUpper] [-IsWhiteSpace] [-NotWhiteSpace] [-IsWord] [-NotWord] [<CommonParameters>]
```

### Char
```
Get-CharacterDetails.ps1 -Char <String> [-IsControl] [-NotControl] [-IsDigit] [-NotDigit] [-IsHighSurrogate]
 [-NotHighSurrogate] [-IsLegalUserName] [-NotLegalUserName] [-IsLegalFileName] [-NotLegalFileName] [-IsLetter]
 [-NotLetter] [-IsLetterOrDigit] [-NotLetterOrDigit] [-IsLower] [-NotLower] [-IsLowSurrogate]
 [-NotLowSurrogate] [-IsMark] [-NotMark] [-IsNumber] [-NotNumber] [-IsPunctuation] [-NotPunctuation]
 [-IsSeparator] [-NotSeparator] [-IsSurrogate] [-NotSurrogate] [-IsSymbol] [-NotSymbol] [-IsUpper] [-NotUpper]
 [-IsWhiteSpace] [-NotWhiteSpace] [-IsWord] [-NotWord] [<CommonParameters>]
```

### Value
```
Get-CharacterDetails.ps1 [-Value] <Int32> [-IsControl] [-NotControl] [-IsDigit] [-NotDigit] [-IsHighSurrogate]
 [-NotHighSurrogate] [-IsLegalUserName] [-NotLegalUserName] [-IsLegalFileName] [-NotLegalFileName] [-IsLetter]
 [-NotLetter] [-IsLetterOrDigit] [-NotLetterOrDigit] [-IsLower] [-NotLower] [-IsLowSurrogate]
 [-NotLowSurrogate] [-IsMark] [-NotMark] [-IsNumber] [-NotNumber] [-IsPunctuation] [-NotPunctuation]
 [-IsSeparator] [-NotSeparator] [-IsSurrogate] [-NotSurrogate] [-IsSymbol] [-NotSymbol] [-IsUpper] [-NotUpper]
 [-IsWhiteSpace] [-NotWhiteSpace] [-IsWord] [-NotWord] [<CommonParameters>]
```

### Range
```
Get-CharacterDetails.ps1 [-StartValue] <Int32> [-StopValue] <Int32> [-IsControl] [-NotControl] [-IsDigit]
 [-NotDigit] [-IsHighSurrogate] [-NotHighSurrogate] [-IsLegalUserName] [-NotLegalUserName] [-IsLegalFileName]
 [-NotLegalFileName] [-IsLetter] [-NotLetter] [-IsLetterOrDigit] [-NotLetterOrDigit] [-IsLower] [-NotLower]
 [-IsLowSurrogate] [-NotLowSurrogate] [-IsMark] [-NotMark] [-IsNumber] [-NotNumber] [-IsPunctuation]
 [-NotPunctuation] [-IsSeparator] [-NotSeparator] [-IsSurrogate] [-NotSurrogate] [-IsSymbol] [-NotSymbol]
 [-IsUpper] [-NotUpper] [-IsWhiteSpace] [-NotWhiteSpace] [-IsWord] [-NotWord] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-CharacterDetails.ps1 ASCII |Out-GridView
```

Learn everything about 7-bit ASCII, the first 128 characters in the Unicode standard.

### EXAMPLE 2
```
Get-CharacterDetails.ps1 GeneralPunctuation -IsSymbol
```

Returns the two characters in the GeneralPunctuation block categorized as symbols.

### EXAMPLE 3
```
Get-CharacterDetails.ps1 ASCII -IsWord -NotLetter -NotDigit
```

Character           : _
Value               : 95
CodePoint           : U+005F
UnicodeBlock        : BasicLatin
MatchesBlock        : True
UnicodeCategory     : ConnectorPunctuation
CategoryClasses     : {Pc, P}
HtmlEncode          : _
HtmlAttributeEncode : _
UrlEncode           : _
HttpUrlEncode       : _
UrlEncodeUnicode    : _
EscapeDataString    : _
EscapeUriString     : _
UrlPathEncode       : _
IsControl           : False
IsDigit             : False
IsHighSurrogate     : False
IsLegalUserName     : True
IsLegalFileName     : True
IsLetter            : False
IsLetterOrDigit     : False
IsLower             : False
IsLowSurrogate      : False
IsMark              : False
IsNumber            : False
IsPunctuation       : True
IsSeparator         : False
IsSurrogate         : False
IsSymbol            : False
IsUpper             : False
IsWhiteSpace        : False
IsWord              : True

## PARAMETERS

### -Block
A specific Unicode block (or named range) of characters to return.

```yaml
Type: String
Parameter Sets: Block
Aliases:

Required: False
Position: 1
Default value: BasicMultilingualPlane
Accept pipeline input: False
Accept wildcard characters: False
```

### -Char
A string containing one or more characters to get details for.

```yaml
Type: String
Parameter Sets: Char
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Value
A codepoint to get details for.

```yaml
Type: Int32
Parameter Sets: Value
Aliases: CodePoint

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartValue
The minimum character in the range to return.

```yaml
Type: Int32
Parameter Sets: Range
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StopValue
The maximum character in the range to return.

```yaml
Type: Int32
Parameter Sets: Range
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsControl
{{ Fill IsControl Description }}

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

### -NotControl
{{ Fill NotControl Description }}

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

### -IsDigit
{{ Fill IsDigit Description }}

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

### -NotDigit
{{ Fill NotDigit Description }}

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

### -IsHighSurrogate
{{ Fill IsHighSurrogate Description }}

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

### -NotHighSurrogate
{{ Fill NotHighSurrogate Description }}

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

### -IsLegalUserName
{{ Fill IsLegalUserName Description }}

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

### -NotLegalUserName
{{ Fill NotLegalUserName Description }}

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

### -IsLegalFileName
{{ Fill IsLegalFileName Description }}

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

### -NotLegalFileName
{{ Fill NotLegalFileName Description }}

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

### -IsLetter
{{ Fill IsLetter Description }}

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

### -NotLetter
{{ Fill NotLetter Description }}

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

### -IsLetterOrDigit
{{ Fill IsLetterOrDigit Description }}

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

### -NotLetterOrDigit
{{ Fill NotLetterOrDigit Description }}

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

### -IsLower
{{ Fill IsLower Description }}

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

### -NotLower
{{ Fill NotLower Description }}

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

### -IsLowSurrogate
{{ Fill IsLowSurrogate Description }}

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

### -NotLowSurrogate
{{ Fill NotLowSurrogate Description }}

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

### -IsMark
{{ Fill IsMark Description }}

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

### -NotMark
{{ Fill NotMark Description }}

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

### -IsNumber
{{ Fill IsNumber Description }}

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

### -NotNumber
{{ Fill NotNumber Description }}

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

### -IsPunctuation
{{ Fill IsPunctuation Description }}

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

### -NotPunctuation
{{ Fill NotPunctuation Description }}

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

### -IsSeparator
{{ Fill IsSeparator Description }}

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

### -NotSeparator
{{ Fill NotSeparator Description }}

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

### -IsSurrogate
{{ Fill IsSurrogate Description }}

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

### -NotSurrogate
{{ Fill NotSurrogate Description }}

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

### -IsSymbol
{{ Fill IsSymbol Description }}

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

### -NotSymbol
{{ Fill NotSymbol Description }}

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

### -IsUpper
{{ Fill IsUpper Description }}

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

### -NotUpper
{{ Fill NotUpper Description }}

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

### -IsWhiteSpace
{{ Fill IsWhiteSpace Description }}

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

### -NotWhiteSpace
{{ Fill NotWhiteSpace Description }}

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

### -IsWord
{{ Fill IsWord Description }}

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

### -NotWord
{{ Fill NotWord Description }}

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

### System.String to get details on each character of.
## OUTPUTS

### System.Management.Automation.PSCustomObject with the following properties:
### Character
### The character these details apply to.
### Value
### The integer codepoint value of the character.
### CodePoint
### The Unicode code point, U+9999 formatted.
### UnicodeBlock
### The Unicode (not .NET) block the character falls into.
### MatchesBlock
### True if the character matches the \p{IsUnicodeBlock} regular expression
### (where "UnicodeBlock" is the character's UnicodeBlock property).
### Error if the character's UnicodeBlock property is not supported by .NET.
### UnicodeCategory
### The .NET UnicodeCategory returned by System.Char.GetUnicodeCategory().
### CategoryClasses
### The list of Unicode general category classes that will match the character.
### PasswordCategory
### The passfilt.dll category of the character:
### Uppercase, Lowercase, Caseless, Digit, or Special.
### ActiveDirectory complexity rules typically require a character from at least
### three of these fairly arbitrary categories.
### HtmlEncode
### The result of HTML-encoding the character using
### System.Net.WebUtility.HtmlEncode().
### HtmlAttributeEncode
### The result of HTML-encoding the character using
### System.Web.HttpUtility.HtmlAttributeEncode().
### UrlEncode
### The result of URL-encoding the character using
### System.Net.WebUtility.UrlEncode().
### HttpUrlEncode
### The result of URL-encoding a string containing the character using the venerable
### System.Web.HttpUtility.UrlEncode().
### UrlEncodeUnicode
### The result of URL-encoding the character using the deprecated
### System.Web.HttpUtility.UrlEncodeUnicode().
### This is the only URL-encoding method in .NET that seems to support encoding
### characters to the %uFFFF syntax, rather than trying to encode characters into
### individual UTF-8 bytes and URL-encoding each of those.
### EscapeDataString
### The result of URL-encoding the character using System.Uri.EscapeDataString(),
### or the name of the exception thrown, usually MethodInvocationException for surrogates.
### EscapeUriString
### The result of URL-encoding the character using System.Uri.EscapeUriString(),
### or the name of the exception thrown, usually MethodInvocationException for surrogates.
### UrlPathEncode
### The result of URL-encoding the character using
### System.Web.HttpUtility.UrlPathEncode().
### IsControl
### The value returned by System.Char.IsControl().
### Indicates whether the specified Unicode character is categorized as a control character.
### When true, the character should match \p{C} in regular expressions.
### IsDigit
### The value returned by System.Char.IsDigit().
### Indicates whether the specified Unicode character is categorized as a decimal digit.
### When true, the character should match \p{Nd} or \d in regular expressions.
### IsHighSurrogate
### The value returned by System.Char.IsHighSurrogate().
### Indicates whether the specified Char object is a high surrogate.
### Surrogates are used to compose supplementary characters outside the Basic Multilingual
### Plane (BMP, the first 65,536 Unicode codepoints).
### IsLegalUserName
### True if the character is valid in a Windows username.
### IsLegalFileName
### True if the character is valid in a Windows path.
### IsLetter
### The value returned by System.Char.IsLetter().
### Indicates whether the specified Unicode character is categorized as a Unicode letter.
### When true, the character should match \p{L} in regular expressions.
### IsLetterOrDigit
### The value returned by System.Char.IsLetterOrDigit().
### Indicates whether the specified Unicode character is categorized as a letter or a decimal digit.
### IsLower
### The value returned by System.Char.IsLower().
### Indicates whether the specified Unicode character is categorized as a lowercase letter.
### When true, the character should match \p{Ll} in regular expressions.
### IsLowSurrogate
### The value returned by System.Char.IsLowSurrogate().
### Indicates whether the specified Char object is a low surrogate.
### Surrogates are used to compose supplementary characters outside the Basic Multilingual
### Plane (BMP, the first 65,536 Unicode codepoints).
### IsMark
### True if the character matches the regular expression \p{M}.
### This indicates the character is categorized as a diacritic mark.
### IsNumber
### The value returned by System.Char.IsNumber().
### Indicates whether the specified Unicode character is categorized as a number.
### When true, the character should match \p{N} in regular expressions.
### IsPunctuation
### The value returned by System.Char.IsPunctuation().
### Indicates whether the specified Unicode character is categorized as a punctuation mark.
### When true, the character should match \p{P} in regular expressions.
### IsSeparator
### The value returned by System.Char.IsSeparator().
### Indicates whether the specified Unicode character is categorized as a separator character.
### When true, the character should match \p{Z} in regular expressions.
### IsSurrogate
### The value returned by System.Char.IsSurrogate().
### Indicates whether the specified character has a surrogate code unit.
### Surrogates are used to compose supplementary characters outside the Basic Multilingual
### Plane (BMP, the first 65,536 Unicode codepoints).
### When true, the character should match \p{Cs} in regular expressions.
### IsSymbol
### The value returned by System.Char.IsSymbol().
### Indicates whether the specified Unicode character is categorized as a symbol character.
### When true, the character should match \p{S} in regular expressions.
### IsUpper
### The value returned by System.Char.IsUpper().
### Indicates whether the specified Unicode character is categorized as an uppercase letter.
### When true, the character should match \p{Lu} in regular expressions.
### IsWhiteSpace
### The value returned by System.Char.IsWhiteSpace().
### Indicates whether the specified Unicode character is categorized as white space.
### When true, the character should match \p{Zs} or \s in regular expressions.
### IsWord
### True if the character matches the regular expression \w.
### This indicates the character is categorized as a "word" (alphanumeric) character,
### including:
### * L   All letters, including:
### * Ll  Letter, lowercase
### * Lu  Letter, uppercase
### * Lt  Letter, titlecase
### * Lo  Letter, other
### * Lm  Letter, modifier
### * Nd  Number, decimal digit
### * Pc  Punctuation, connector (includes _)
## NOTES

## RELATED LINKS

[http://unicode.org/](http://unicode.org/)

[https://msdn.microsoft.com/library/system.char.aspx](https://msdn.microsoft.com/library/system.char.aspx)

[https://msdn.microsoft.com/library/system.uri.aspx](https://msdn.microsoft.com/library/system.uri.aspx)

[https://msdn.microsoft.com/library/system.globalization.unicodecategory.aspx](https://msdn.microsoft.com/library/system.globalization.unicodecategory.aspx)

[https://msdn.microsoft.com/library/windows/desktop/ms722458.aspx](https://msdn.microsoft.com/library/windows/desktop/ms722458.aspx)

[https://msdn.microsoft.com/library/system.net.webutility.aspx](https://msdn.microsoft.com/library/system.net.webutility.aspx)

[https://msdn.microsoft.com/library/system.web.httputility.aspx](https://msdn.microsoft.com/library/system.web.httputility.aspx)

[https://msdn.microsoft.com/library/20bw873z.aspx](https://msdn.microsoft.com/library/20bw873z.aspx)

[https://msdn.microsoft.com/library/windows/desktop/dd374069.aspx](https://msdn.microsoft.com/library/windows/desktop/dd374069.aspx)

[https://technet.microsoft.com/library/bb726984.aspx](https://technet.microsoft.com/library/bb726984.aspx)

[https://msdn.microsoft.com/library/system.io.path.getinvalidfilenamechars.aspx](https://msdn.microsoft.com/library/system.io.path.getinvalidfilenamechars.aspx)

[https://docs.microsoft.com/dotnet/core/compatibility/3.1-5.0#unicode-category-changed-for-some-latin-1-characters](https://docs.microsoft.com/dotnet/core/compatibility/3.1-5.0#unicode-category-changed-for-some-latin-1-characters)

