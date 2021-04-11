---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/ms143998.aspx
schema: 2.0.0
---

# Get-Dns.ps1

## SYNOPSIS
Looks up DNS info, given a hostname or address.

## SYNTAX

```
Get-Dns.ps1 [-HostName] <String[]> [-OnlyAddresses <AddressFamily>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-Dns.ps1 www.google.com
```

HostName       Aliases AddressList
--------       ------- -----------
www.google.com {}      {172.217.10.132}

## PARAMETERS

### -HostName
A host name or address to look up.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Address, HostAddress, Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OnlyAddresses
Indicates that only the string versions of addresses belonging to the specified family should be returned.
"Unknown" returns all addresses.

```yaml
Type: AddressFamily
Parameter Sets: (All)
Aliases:
Accepted values: Unspecified, Unix, InterNetwork, ImpLink, Pup, Chaos, NS, Ipx, Osi, Iso, Ecma, DataKit, Ccitt, Sna, DecNet, DataLink, Lat, HyperChannel, AppleTalk, NetBios, VoiceView, FireFox, Banyan, Atm, InterNetworkV6, Cluster, Ieee12844, Irda, NetworkDesigners, Max, Packet, ControllerAreaNetwork, Unknown

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String of host names to look up.
## OUTPUTS

### System.Net.IPHostEntry of host DNS entries, or
### System.String of network addresses found.
## NOTES

## RELATED LINKS

[https://msdn.microsoft.com/library/ms143998.aspx](https://msdn.microsoft.com/library/ms143998.aspx)

