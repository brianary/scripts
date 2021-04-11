---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-IisLog.ps1

## SYNOPSIS
Easily query IIS logs.

## SYNTAX

### Server
```
Get-IisLog.ps1 [-ComputerName <String[]>] [[-After] <DateTime>] [[-Before] <DateTime>] [-IpAddr <String[]>]
 [-Username <String[]>] [-Status <Int32[]>] [-Method <WebRequestMethod[]>] [-UriPathLike <String>]
 [-QueryLike <String>] [-ReferrerLike <String>] [<CommonParameters>]
```

### Directory
```
Get-IisLog.ps1 [-LogDirectory <DirectoryInfo[]>] [[-After] <DateTime>] [[-Before] <DateTime>]
 [-IpAddr <String[]>] [-Username <String[]>] [-Status <Int32[]>] [-Method <WebRequestMethod[]>]
 [-UriPathLike <String>] [-QueryLike <String>] [-ReferrerLike <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-IisLog.ps1 -LogDirectory \\Server\c$\inetpub\logs\LogFiles\W3SVC1 -After 2014-03-30 -UriPathLike '/WebApp/%' |select -First 1
```

Time          : 2014-03-31 15:56:45
Server        : 192.168.1.99:80
Filename      : ex140331.log
Line          : 121555
IpAddr        : 192.168.1.199
Username      :
UserAgent     : Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/6.0; SLCC2; .NET CLR
                2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E;
                InfoPath.3)
Method        : GET
UriPath       : /WebApp/
Query         :
Referrer      :
StatusCode    : 401
Status        : Unauthorized
SubStatusCode : 2
SubStatus     : Logon failed due to server configuration.
WinStatusCode : 5
WinStatus     : Access is denied

## PARAMETERS

### -ComputerName
Attempts to use the LogFiles$ share of the computers listed as the log directory.

```yaml
Type: String[]
Parameter Sets: Server
Aliases: Server, CN

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogDirectory
The directory(ies) containing the log files to query.

```yaml
Type: DirectoryInfo[]
Parameter Sets: Directory
Aliases: Dir

Required: False
Position: Named
Default value: $PWD.ProviderPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -After
The minimum datetime to query.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: [datetime]::MinValue
Accept pipeline input: False
Accept wildcard characters: False
```

### -Before
The maximum datetime to query.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 8191-12-31
Accept pipeline input: False
Accept wildcard characters: False
```

### -IpAddr
The client IP address(es) to restrict the query to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: ClientIP

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username to restrict the search to.

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

### -Status
The HTTP (major) status to restrict the search to.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The HTTP method (GET or POST, &c) to restrict the search to.

```yaml
Type: WebRequestMethod[]
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UriPathLike
A "like" pattern to match against the requested URI stem/path.

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

### -QueryLike
A "like" pattern to match against the query string.

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

### -ReferrerLike
A "like" pattern to match against the HTTP referrer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: RefererLike

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

### System.Management.Automation.PSObject[] with properties from the log file
### for each request found:
### 	* Time: DateTime of the request.
### 	* Server: Address of the server.
### 	* Filename: Which log file the request was found in.
### 	* Line: The line of the log file containing the request detail.
### 	* IpAddr: The client address.
### 	* Username: The username of an authenticated request.
### 	* UserAgent: The browser identification string send by the client.
### 	* Method: The HTTP verb used by the request.
### 	* UriPath: The location on the web server requested.
### 	* Query: The GET query parameters requested.
### 	* Referrer: The location that linked to this request, if provided.
### 	* Status: The HTTP success/error code of the response.
## NOTES

## RELATED LINKS

[ConvertFrom-Csv]()

[Use-Command.ps1]()

[https://www.microsoft.com/download/details.aspx?id=24659](https://www.microsoft.com/download/details.aspx?id=24659)

[https://docs.microsoft.com/windows/win32/debug/system-error-codes](https://docs.microsoft.com/windows/win32/debug/system-error-codes)

[https://support.microsoft.com/help/943891/the-http-status-code-in-iis-7-0-iis-7-5-and-iis-8-0](https://support.microsoft.com/help/943891/the-http-status-code-in-iis-7-0-iis-7-5-and-iis-8-0)

[https://docs.microsoft.com/dotnet/api/system.net.http.httpresponsemessage.statuscode](https://docs.microsoft.com/dotnet/api/system.net.http.httpresponsemessage.statuscode)

[https://docs.microsoft.com/dotnet/api/system.componentmodel.win32exception](https://docs.microsoft.com/dotnet/api/system.componentmodel.win32exception)

