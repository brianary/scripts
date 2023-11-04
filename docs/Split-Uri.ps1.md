---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Split-Uri.ps1

## SYNOPSIS
Splits a URI into component parts.

## SYNTAX

### AbsolutePath
```
Split-Uri.ps1 [-Uri] <Uri> [-AbsolutePath] [<CommonParameters>]
```

### Authority
```
Split-Uri.ps1 [-Uri] <Uri> [-Authority] [<CommonParameters>]
```

### Credentials
```
Split-Uri.ps1 [-Uri] <Uri> [-Credential] [<CommonParameters>]
```

### Extension
```
Split-Uri.ps1 [-Uri] <Uri> [-Extension] [<CommonParameters>]
```

### Filename
```
Split-Uri.ps1 [-Uri] <Uri> [-Filename <String>] [<CommonParameters>]
```

### HostNameType
```
Split-Uri.ps1 [-Uri] <Uri> [-HostNameType] [<CommonParameters>]
```

### IsAbsoluteUri
```
Split-Uri.ps1 [-Uri] <Uri> [-IsAbsoluteUri] [<CommonParameters>]
```

### IsDefaultPort
```
Split-Uri.ps1 [-Uri] <Uri> [-IsDefaultPort] [<CommonParameters>]
```

### IsFile
```
Split-Uri.ps1 [-Uri] <Uri> [-IsFile] [<CommonParameters>]
```

### IsLoopback
```
Split-Uri.ps1 [-Uri] <Uri> [-IsLoopback] [<CommonParameters>]
```

### IsUnc
```
Split-Uri.ps1 [-Uri] <Uri> [-IsUnc] [<CommonParameters>]
```

### Leaf
```
Split-Uri.ps1 [-Uri] <Uri> [-Leaf] [<CommonParameters>]
```

### LeafBase
```
Split-Uri.ps1 [-Uri] <Uri> [-LeafBase] [<CommonParameters>]
```

### ParentPath
```
Split-Uri.ps1 [-Uri] <Uri> [-ParentPath] [<CommonParameters>]
```

### ParentUri
```
Split-Uri.ps1 [-Uri] <Uri> [-ParentUri] [<CommonParameters>]
```

### Hostname
```
Split-Uri.ps1 [-Uri] <Uri> [-Hostname] [<CommonParameters>]
```

### IdnHost
```
Split-Uri.ps1 [-Uri] <Uri> [-IdnHost] [<CommonParameters>]
```

### LocalPath
```
Split-Uri.ps1 [-Uri] <Uri> [-LocalPath] [<CommonParameters>]
```

### PathAndQuery
```
Split-Uri.ps1 [-Uri] <Uri> [-PathAndQuery] [<CommonParameters>]
```

### Port
```
Split-Uri.ps1 [-Uri] <Uri> [-Port] [<CommonParameters>]
```

### Query
```
Split-Uri.ps1 [-Uri] <Uri> [-Query] [<CommonParameters>]
```

### QueryAsDictionary
```
Split-Uri.ps1 [-Uri] <Uri> [-QueryAsDictionary] [<CommonParameters>]
```

### Scheme
```
Split-Uri.ps1 [-Uri] <Uri> [-Scheme] [<CommonParameters>]
```

### Segment
```
Split-Uri.ps1 [-Uri] <Uri> [-Segment <Int32>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Split-Uri.ps1 https://webcoder.info/wps-to-psc.html -Leaf
```

wps-to-psc.html

### EXAMPLE 2
```
Split-Uri.ps1 https://webcoder.info/wps-to-psc.html -IsAbsoluteUri
```

True

### EXAMPLE 3
```
Split-Uri.ps1 https://webcoder.info/wps-to-psc.html -Authority
```

webcoder.info

### EXAMPLE 4
```
Split-Uri.ps1 'http://example.net/q?one=something&one=another%20thing&two=second' -QueryAsDictionary
```

Name  Value
----  -----
one   {something, another thing}
two   second

## PARAMETERS

### -Uri
Specifies the URI to split.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: Url, Href, Src

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -AbsolutePath
Indicates the absolute path of the URI should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: AbsolutePath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Authority
Indicates the host/IP and port of the URI (as used to define security contexts) should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: Authority
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Indicates the credential of the URI should be returned, if a username and/or password was provided.

```yaml
Type: SwitchParameter
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Extension
Indicates the filename extension of the URI should be returned, if one is available.

```yaml
Type: SwitchParameter
Parameter Sets: Extension
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filename
Indicates the filename of the new URI should be returned, or the default value if one is not available.
Supports format specifiers, {0} for the current date and time and {1} for a GUID.

```yaml
Type: String
Parameter Sets: Filename
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostNameType
Indicates the type of the hostname of the URI should be returned: Basic, Dns, IPv4, IPv6, Unknown.

```yaml
Type: SwitchParameter
Parameter Sets: HostNameType
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsAbsoluteUri
Indicates $true should be returned if the URI is absolute, $false otherwise.

```yaml
Type: SwitchParameter
Parameter Sets: IsAbsoluteUri
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsDefaultPort
Indicates $true should be returned if the URI specifies a default port, $false otherwise.

```yaml
Type: SwitchParameter
Parameter Sets: IsDefaultPort
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsFile
Indicates $true should be returned if the URI is a file: URI, $false otherwise.

```yaml
Type: SwitchParameter
Parameter Sets: IsFile
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsLoopback
Indicates $true should be returned if the URI references the localhost, $false otherwise.

```yaml
Type: SwitchParameter
Parameter Sets: IsLoopback
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsUnc
Indicates $true should be returned if the URI is a UNC path, $false otherwise.

```yaml
Type: SwitchParameter
Parameter Sets: IsUnc
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Leaf
Indicates the final segment of the URI should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: Leaf
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LeafBase
Indicates the final segment of the URI should be returned, without any filename extension.

```yaml
Type: SwitchParameter
Parameter Sets: LeafBase
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentPath
Indicates the path of the URI should be returned, without the final segment.

```yaml
Type: SwitchParameter
Parameter Sets: ParentPath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentUri
Indicates the URI should be returned, without the final segment.

```yaml
Type: SwitchParameter
Parameter Sets: ParentUri
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
Indicates the hostname of the URI should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: Hostname
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdnHost
Indicates the IDN hostname of the URI should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: IdnHost
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocalPath
Indicates the OS-localized path of the URI should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: LocalPath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PathAndQuery
Indicates the absolute path and query of the URI should be returned, separated by '?'.

```yaml
Type: SwitchParameter
Parameter Sets: PathAndQuery
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Indicates the port number of the URI should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: Port
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
Indicates the querystring of the URI should be returned, including the leading '?'.

```yaml
Type: SwitchParameter
Parameter Sets: Query
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryAsDictionary
Indicates the querystring of the URI should be returned, as a Hashtable.

```yaml
Type: SwitchParameter
Parameter Sets: QueryAsDictionary
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scheme
Indicates the scheme of the URI should be returned (http, &c), without the trailing ':'.

```yaml
Type: SwitchParameter
Parameter Sets: Scheme
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Segment
Indicates the specified segment index of the URI should be returned, if is available.

```yaml
Type: Int32
Parameter Sets: Segment
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Uri containing a URI to extract a part of.
## OUTPUTS

### System.String for various URI parts that are extracted (usually), or
### System.Boolean for various tests of the URI parts, or
### System.Int32 to identify the port number if requsted, or
### System.UriHostNameType to identify the type of hostname if requested, or
### System.Collections.Hashtable containing the querystring name and value pairs if requested, or
### System.Management.Automation.PSCredential containing the username and password of the URI if requested.
## NOTES

## RELATED LINKS
