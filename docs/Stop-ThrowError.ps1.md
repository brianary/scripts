---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.management.automation.cmdlet.throwterminatingerror
schema: 2.0.0
---

# Stop-ThrowError.ps1

## SYNOPSIS
Throws a better error than "throw".

## SYNTAX

### Detailed
```
Stop-ThrowError.ps1 [-ExceptionType] <Type> [-ExceptionArguments] <Object[]> [-ErrorCategory] <ErrorCategory>
 [-TargetObject] <Object> [[-ErrorId] <String>] [<CommonParameters>]
```

### CatchBlock
```
Stop-ThrowError.ps1 [[-ExceptionType] <Type>] [[-ExceptionArguments] <Object[]>] [<CommonParameters>]
```

### NotImplemented
```
Stop-ThrowError.ps1 [-Message] <String> [-NotImplemented] [<CommonParameters>]
```

### ObjectNotFound
```
Stop-ThrowError.ps1 [-Message] <String> [<CommonParameters>]
```

### InvalidOperation
```
Stop-ThrowError.ps1 [-Message] <String> -OperationContext <Object> [<CommonParameters>]
```

### InvalidArgument
```
Stop-ThrowError.ps1 [-Message] <String> -Argument <String> [<CommonParameters>]
```

### Format
```
Stop-ThrowError.ps1 [-Message] <String> -Format <String> -InputString <String> [<CommonParameters>]
```

### ItemNotFound
```
Stop-ThrowError.ps1 -SearchContext <Object> [<CommonParameters>]
```

## DESCRIPTION
The PowerShell "throw" keyword doesn't do a good job of providing actionable
detail or context:

	Unable to remove root node.
	At C:\Scripts\Remove-Xml.ps1:34 char:37
	+ ... 
if($node.ParentNode -eq $null) {throw 'Unable to remove root node.'}
	+                                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		+ CategoryInfo          : OperationStopped: (Unable to remove root node.:String) \[\], RuntimeException
		+ FullyQualifiedErrorId : Unable to remove root node.

It only shows where the "throw" was used in the called script!

Using $PSCmdlet.ThrowTerminatingError() does a much better job:

	C:\Scripts\Remove-Xml.ps1 : Unable to remove root node
	Parameter name: SelectXmlInfo
	At C:\Scripts\Test-Error.ps1:2 char:23
	+ '\<a/\>' |Select-Xml / |Remove-Xml.ps1
	+                       ~~~~~~~~~~~~~~
		+ CategoryInfo          : InvalidArgument: (\<a /\>:SelectXmlInfo) \[Remove-Xml.ps1\], ArgumentException
		+ FullyQualifiedErrorId : RootRequired,Remove-Xml.ps1

Now you can see where the trouble is in the calling script!

However, contructing an exception, then using that to construct an error with the right ID & category &
target object, then using that to call ThrowTerminatingError() is pretty inconvenient.

This script combines that process into a few simple parameters.

## EXAMPLES

### EXAMPLE 1
```
Stop-ThrowError.ps1 'Unable to remove root node' -Argument SelectXmlInfo
```

C:\Scripts\Remove-Xml.ps1 : Unable to remove root node
Parameter name: SelectXmlInfo
At C:\Scripts\Test-Error.ps1:2 char:23
+ '\<a/\>' |Select-Xml / |Remove-Xml.ps1
+                       ~~~~~~~~~~~~~~
	+ CategoryInfo          : InvalidArgument: (\<a /\>:SelectXmlInfo) \[Remove-Xml.ps1\], ArgumentException
	+ FullyQualifiedErrorId : SelectXmlInfo,Remove-Xml.ps1

### EXAMPLE 2
```
if(Test-Uri.ps1 $u) {[uri]$u} else {Stop-ThrowError.ps1 'Bad URL' -Format URL -InputString $u}
```

(Fails for non-uri values of $u.)

## PARAMETERS

### -ExceptionType
The type of a Exception class to instantiate as part of the error.

```yaml
Type: Type
Parameter Sets: Detailed
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Type
Parameter Sets: CatchBlock
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExceptionArguments
The constructor parameters for the exception class specified by ExceptionTypeName.

```yaml
Type: Object[]
Parameter Sets: Detailed
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Object[]
Parameter Sets: CatchBlock
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorCategory
The error's category, as an enumeration value.

```yaml
Type: ErrorCategory
Parameter Sets: Detailed
Aliases:
Accepted values: NotSpecified, OpenError, CloseError, DeviceError, DeadlockDetected, InvalidArgument, InvalidData, InvalidOperation, InvalidResult, InvalidType, MetadataError, NotImplemented, NotInstalled, ObjectNotFound, OperationStopped, OperationTimeout, SyntaxError, ParserError, PermissionDenied, ResourceBusy, ResourceExists, ResourceUnavailable, ReadError, WriteError, FromStdErr, SecurityError, ProtocolError, ConnectionError, AuthenticationError, LimitsExceeded, QuotaExceeded, NotEnabled

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetObject
The object in context when the error happened.

```yaml
Type: Object
Parameter Sets: Detailed
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorId
An string unique to the script that identifies the error.
By default this will use the line number it is called from.

```yaml
Type: String
Parameter Sets: Detailed
Aliases:

Required: False
Position: 5
Default value: "L$(Get-PSCallStack |select -First 1 |% ScriptLineNumber)"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
{{ Fill Message Description }}

```yaml
Type: String
Parameter Sets: NotImplemented, ObjectNotFound, InvalidOperation, InvalidArgument, Format
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Format
The data format the string failed to parse as.

```yaml
Type: String
Parameter Sets: Format
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputString
The string that failed to parse.

```yaml
Type: String
Parameter Sets: Format
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Argument
The parameter name that had a bad value.

```yaml
Type: String
Parameter Sets: InvalidArgument
Aliases: InvalidArgument

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OperationContext
An object containing the state that failed to process.

```yaml
Type: Object
Parameter Sets: InvalidOperation
Aliases: InvalidOperation

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchContext
An object containing the search detail that failed.

```yaml
Type: Object
Parameter Sets: ItemNotFound
Aliases: ObjectNotFound

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotImplemented
Indicates that the exception represents incomplete functionality.

```yaml
Type: SwitchParameter
Parameter Sets: NotImplemented
Aliases:

Required: True
Position: Named
Default value: False
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

[https://docs.microsoft.com/dotnet/api/system.management.automation.cmdlet.throwterminatingerror](https://docs.microsoft.com/dotnet/api/system.management.automation.cmdlet.throwterminatingerror)

[https://docs.microsoft.com/dotnet/api/system.management.automation.errorrecord.-ctor](https://docs.microsoft.com/dotnet/api/system.management.automation.errorrecord.-ctor)

[Get-Variable]()

[New-Object]()

