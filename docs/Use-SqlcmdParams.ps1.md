---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Use-SqlcmdParams.ps1

## SYNOPSIS
Use the calling script parameters to set Invoke-Sqlcmd defaults.

## SYNTAX

```
Use-SqlcmdParams.ps1 [[-HostName] <String>] [[-QueryTimeout] <Int32>] [[-ConnectionTimeout] <Int32>]
 [[-ErrorLevel] <Int32>] [[-SeverityLevel] <Int32>] [[-MaxCharLength] <Int32>] [[-MaxBinaryLength] <Int32>]
 [-DisableVariables] [-DisableCommands] [-EncryptConnection] [<CommonParameters>]
```

## DESCRIPTION
This script uses the ParameterSetName in use in the calling script to determine
which set of the calling script's parameters to set as defaults for the
Invoke-Sqlcmd cmdlet.

The same ParameterSetNames as Invoke-Sqlcmd are used, plus ConnectionName to
pull a connection string from the .NET configuration.

To use this script, add any or all of these parameter sets:

\[CmdletBinding()\] Param(
\[Parameter(ParameterSetName='ByConnectionParameters',Mandatory=$true)\]\[string\]$ServerInstance,
\[Parameter(ParameterSetName='ByConnectionParameters')\]\[string\]$Database,
\[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)\]\[string\]$ConnectionString,
\[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)\]\[string\]$ConnectionName
# ...
)

Or, if you wish to support Use-SqlcmdParams.ps1 in scripts that call your script:

\[CmdletBinding()\] Param(
\[Parameter(ParameterSetName='ByConnectionParameters')\]\[string\]$ServerInstance =
    $PSDefaultParameterValues\['Invoke-Sqlcmd:ServerInstance'\],
\[Parameter(ParameterSetName='ByConnectionParameters')\]\[string\]$Database =
    $PSDefaultParameterValues\['Invoke-Sqlcmd:Database'\],
\[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)\]\[string\]$ConnectionString,
\[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)\]\[string\]$ConnectionName
# ...
)

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -HostName
{{ Fill HostName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryTimeout
{{ Fill QueryTimeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionTimeout
{{ Fill ConnectionTimeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorLevel
{{ Fill ErrorLevel Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SeverityLevel
{{ Fill SeverityLevel Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxCharLength
{{ Fill MaxCharLength Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxBinaryLength
{{ Fill MaxBinaryLength Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableVariables
{{ Fill DisableVariables Description }}

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

### -DisableCommands
{{ Fill DisableCommands Description }}

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

### -EncryptConnection
{{ Fill EncryptConnection Description }}

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

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Import-Variables.ps1]()

