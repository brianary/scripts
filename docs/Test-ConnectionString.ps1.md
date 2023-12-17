---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Test-ConnectionString.ps1

## SYNOPSIS
Test a given connection string and provide details about the connection.

## SYNTAX

```
Test-ConnectionString.ps1 [-ConnectionString] <String> [-Details] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-ConnectionString.ps1 'Server=(localdb)\ProjectsV13;Integrated Security=SSPI;Encrypt=True'
```

ServerName           : SERVERNAME\LOCALDB#DCCC9EEC
AppName              : Core Microsoft SqlClient Data Provider
LocalRunAsAdmin      : False
ConnectingAsUser     : SERVERNAME\username
SqlInstance          : (localdb)\ProjectsV13
LocalWindows         : 10.0.19045.0
InstanceName         : LOCALDB#DCCC9EEC
DatabaseName         : master
AuthType             : Windows Authentication
Integrated Security  : True
Data Source          : (localdb)\ProjectsV13
ConnectSuccess       : True
Workstation ID       : SERVERNAME
AuthScheme           : NTLM
ComputerName         : SERVERNAME
Encrypt              : True
LocalCLR             : 
TcpPort              : 1433
LocalPowerShell      : 7.3.9
NetBiosName          : SERVERNAME
Edition              : Express Edition (64-bit)
IPAddress            : 192.168.1.223
ServerTime           : 2023-11-10 12:14:09
DomainName           : WORKGROUP
Server               : \[(localdb)\ProjectsV13\]
IsPingable           : True
LocalEdition         : Core
Pooling              : True
LocalDomainUser      : False
MachineName          : SERVERNAME
SqlVersion           : 13.0.4001
LocalSMOVersion      : 17.100.0.0

## PARAMETERS

### -ConnectionString
{{ Fill ConnectionString Description }}

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

### -Details
{{ Fill Details Description }}

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject containing properties about the connection.
## NOTES

## RELATED LINKS
