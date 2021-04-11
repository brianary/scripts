---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Send-SqlReport.ps1

## SYNOPSIS
Execute a SQL statement and email the results.

## SYNTAX

### ByConnectionParameters
```
Send-SqlReport.ps1 [-Subject] <String> [-To] <String[]> [-Sql] <String> [[-ServerInstance] <String>]
 [[-Database] <String>] [-EmptySubject <String>] [-From <String>] [-Caption <String>] [-ReportFile <String>]
 [-QueryTimeout <Int32>] [-PreContent <String>] [-PostContent <String>] [-Cc <String[]>] [-Bcc <String[]>]
 [-Priority <MailPriority>] [-UseSsl] [-SeqUrl <Uri>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByConnectionString
```
Send-SqlReport.ps1 [-Subject] <String> [-To] <String[]> [-Sql] <String> -ConnectionString <String>
 [-EmptySubject <String>] [-From <String>] [-Caption <String>] [-ReportFile <String>] [-QueryTimeout <Int32>]
 [-PreContent <String>] [-PostContent <String>] [-Cc <String[]>] [-Bcc <String[]>] [-Priority <MailPriority>]
 [-UseSsl] [-SeqUrl <Uri>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByConnectionName
```
Send-SqlReport.ps1 [-Subject] <String> [-To] <String[]> [-Sql] <String> -ConnectionName <String>
 [-EmptySubject <String>] [-From <String>] [-Caption <String>] [-ReportFile <String>] [-QueryTimeout <Int32>]
 [-PreContent <String>] [-PostContent <String>] [-Cc <String[]>] [-Bcc <String[]>] [-Priority <MailPriority>]
 [-UseSsl] [-SeqUrl <Uri>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Subject
The email subject.

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

### -To
The email address(es) to send the results to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sql
The SQL statement to execute.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
The name of a server (and optional instance) to connect and use for the query.

```yaml
Type: String
Parameter Sets: ByConnectionParameters
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Database
The the database to connect to on the server.

```yaml
Type: String
Parameter Sets: ByConnectionParameters
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionString
Specifies a connection string to connect to the server.

```yaml
Type: String
Parameter Sets: ByConnectionString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConnectionName
The connection string name from the ConfigurationManager to use when executing the query.

```yaml
Type: String
Parameter Sets: ByConnectionName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmptySubject
The subject line for the email when no data is returned.

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

### -From
The from address to use for the email.
The default is to use $PSEmailServer.
If that is missing, it will be populated by the value from the
configuration value:

\<system.net\>
  \<mailSettings\>
    \<smtp from="source@example.org" deliveryMethod="network"\>
      \<network host="mail.example.org" enableSsl="true" /\>
    \</smtp\>
  \</mailSettings\>
\</system.net\>

(If enableSsl is set to true, SSL will be used to send the report.)

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

### -Caption
The optional table caption to add.

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

### -ReportFile
A UNC path to a .csv or .tsv file writable by the script and readable by the email recipient to output the data to,
which will be linked in the email rather than included in the email body.

Supports a format template for the current date and time (e.g.
{0:yyyyMMddHHmmss}).

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

### -QueryTimeout
{{ Fill QueryTimeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Timeout

Required: False
Position: Named
Default value: 90
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreContent
HTML content to insert into the email before the query results.

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

### -PostContent
HTML content to insert into the email after the query results.

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

### -Cc
The email address(es) to CC the results to.

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

### -Bcc
The email address(es) to BCC the results to.

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

### -Priority
The priority of the email, one of: High, Low, Normal

```yaml
Type: MailPriority
Parameter Sets: (All)
Aliases:
Accepted values: Normal, Low, High

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSsl
Indicates that SSL should be used when sending the message.

(See the From parameter for an alternate SSL flag.)

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

### -SeqUrl
{{ Fill SeqUrl Description }}

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PSDefaultParameterValues['Send-SeqEvent.ps1:Server']
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

### System.Void
## NOTES

## RELATED LINKS

[Use-SqlcmdParams.ps1]()

[Send-MailMessage]()

[Invoke-Sqlcmd]()

