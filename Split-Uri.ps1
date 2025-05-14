<#
.SYNOPSIS
Splits a URI into component parts.

.INPUTS
System.Uri containing a URI to extract a part of.

.OUTPUTS
System.String for various URI parts that are extracted (usually), or
System.Boolean for various tests of the URI parts, or
System.Int32 to identify the port number if requsted, or
System.UriHostNameType to identify the type of hostname if requested, or
System.Collections.Hashtable containing the querystring name and value pairs if requested, or
System.Management.Automation.PSCredential containing the username and password of the URI if requested.

.FUNCTIONALITY
Data formats

.EXAMPLE
Split-Uri.ps1 https://webcoder.info/wps-to-psc.html -Leaf

wps-to-psc.html

.EXAMPLE
Split-Uri.ps1 https://webcoder.info/wps-to-psc.html -IsAbsoluteUri

True

.EXAMPLE
Split-Uri.ps1 https://webcoder.info/wps-to-psc.html -Authority

webcoder.info

.EXAMPLE
Split-Uri.ps1 'http://example.net/q?one=something&one=another%20thing&two=second' -QueryAsDictionary

Name  Value
----  -----
one   {something, another thing}
two   second
#>

#Requires -Version 3
[OutputType([string],ParameterSetName='AbsolutePath')]
[OutputType([string],ParameterSetName='Authority')]
[OutputType([pscredential],ParameterSetName='Credential')]
[OutputType([string],ParameterSetName='Extension')]
[OutputType([string],ParameterSetName='Filename')]
[OutputType([UriHostNameType],ParameterSetName='HostNameType')]
[OutputType([bool],ParameterSetName='IsAbsoluteUri')]
[OutputType([bool],ParameterSetName='IsDefaultPort')]
[OutputType([bool],ParameterSetName='IsFile')]
[OutputType([bool],ParameterSetName='IsLoopback')]
[OutputType([bool],ParameterSetName='IsUnc')]
[OutputType([string],ParameterSetName='Leaf')]
[OutputType([string],ParameterSetName='LeafBase')]
[OutputType([string],ParameterSetName='ParentPath')]
[OutputType([string],ParameterSetName='ParentUri')]
[OutputType([string],ParameterSetName='HostPart')]
[OutputType([string],ParameterSetName='IdnHost')]
[OutputType([string],ParameterSetName='LocalPath')]
[OutputType([string],ParameterSetName='PathAndQuery')]
[OutputType([int],ParameterSetName='Port')]
[OutputType([string],ParameterSetName='Query')]
[OutputType([hashtable],ParameterSetName='QueryAsDictionary')]
[OutputType([string],ParameterSetName='Scheme')]
[OutputType([string],ParameterSetName='Segment')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText','',
Justification='The data source is plaintext. SecureString benefits may be in dispute: <https://github.com/dotnet/platform-compat/blob/master/docs/DE0001.md>')]
[CmdletBinding()] Param(
# Specifies the URI to split.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('Url','Href','Src')][uri] $Uri,
# Indicates the absolute path of the URI should be returned.
[Parameter(ParameterSetName='AbsolutePath')][switch] $AbsolutePath,
# Indicates the host/IP and port of the URI (as used to define security contexts) should be returned.
[Parameter(ParameterSetName='Authority')][switch] $Authority,
# Indicates the credential of the URI should be returned, if a username and/or password was provided.
[Parameter(ParameterSetName='Credentials')][switch] $Credential,
# Indicates the filename extension of the URI should be returned, if one is available.
[Parameter(ParameterSetName='Extension')][switch] $Extension,
# Indicates the filename of the new URI should be returned, or the default value if one is not available.
# Supports format specifiers, {0} for the current date and time and {1} for a GUID.
[Parameter(ParameterSetName='Filename')][string] $Filename,
# Indicates the type of the hostname of the URI should be returned: Basic, Dns, IPv4, IPv6, Unknown.
[Parameter(ParameterSetName='HostNameType')][switch] $HostNameType,
# Indicates $true should be returned if the URI is absolute, $false otherwise.
[Parameter(ParameterSetName='IsAbsoluteUri')][switch] $IsAbsoluteUri,
# Indicates $true should be returned if the URI specifies a default port, $false otherwise.
[Parameter(ParameterSetName='IsDefaultPort')][switch] $IsDefaultPort,
# Indicates $true should be returned if the URI is a file: URI, $false otherwise.
[Parameter(ParameterSetName='IsFile')][switch] $IsFile,
# Indicates $true should be returned if the URI references the localhost, $false otherwise.
[Parameter(ParameterSetName='IsLoopback')][switch] $IsLoopback,
# Indicates $true should be returned if the URI is a UNC path, $false otherwise.
[Parameter(ParameterSetName='IsUnc')][switch] $IsUnc,
# Indicates the final segment of the URI should be returned.
[Parameter(ParameterSetName='Leaf')][switch] $Leaf,
# Indicates the final segment of the URI should be returned, without any filename extension.
[Parameter(ParameterSetName='LeafBase')][switch] $LeafBase,
# Indicates the path of the URI should be returned, without the final segment.
[Parameter(ParameterSetName='ParentPath')][switch] $ParentPath,
# Indicates the URI should be returned, without the final segment.
[Parameter(ParameterSetName='ParentUri')][switch] $ParentUri,
# Indicates the hostname of the URI should be returned.
[Parameter(ParameterSetName='Hostname')][switch] $Hostname,
# Indicates the IDN hostname of the URI should be returned.
[Parameter(ParameterSetName='IdnHost')][switch] $IdnHost,
# Indicates the OS-localized path of the URI should be returned.
[Parameter(ParameterSetName='LocalPath')][switch] $LocalPath,
# Indicates the absolute path and query of the URI should be returned, separated by '?'.
[Parameter(ParameterSetName='PathAndQuery')][switch] $PathAndQuery,
# Indicates the port number of the URI should be returned.
[Parameter(ParameterSetName='Port')][switch] $Port,
# Indicates the querystring of the URI should be returned, including the leading '?'.
[Parameter(ParameterSetName='Query')][switch] $Query,
# Indicates the querystring of the URI should be returned, as a Hashtable.
[Parameter(ParameterSetName='QueryAsDictionary')][switch] $QueryAsDictionary,
# Indicates the scheme of the URI should be returned (http, &c), without the trailing ':'.
[Parameter(ParameterSetName='Scheme')][switch] $Scheme,
# Indicates the specified segment index of the URI should be returned, if is available.
[Parameter(ParameterSetName='Segment')][int] $Segment
)
Begin
{
	function ConvertFrom-UserInfo
	{
		[CmdletBinding()][OutputType([pscredential])] Param([string] $UserInfo)
		if(!$UserInfo) {return}
		$username,$pw = $UserInfo -split ':',2
		$pw = if($pw) {ConvertTo-SecureString ([uri]::UnescapeDataString($pw)) -AsPlainText -Force} else {[securestring]::new()}
		return New-Object pscredential ([uri]::UnescapeDataString($username)),$pw
	}
	function ConvertFrom-QueryString
	{
		[CmdletBinding()][OutputType([hashtable])] Param([string] $QueryString)
		if(!$QueryString) {return @{}}
		$values = @{}
		foreach($pair in $QueryString.Substring(1) -split '&')
		{
			$key,$value = $pair -split '=',2
			$key,$value = [uri]::UnescapeDataString($key),[uri]::UnescapeDataString($value)
			if(!$values.ContainsKey($key)) {$values.Add($key,$value)}
			elseif($values[$key] -isnot [array]) {$values[$key] = @($values[$key],$value)}
			else {$values[$key] += $value}
			}
		return $values
	}
}
Process
{
	switch ($PSCmdlet.ParameterSetName)
	{
		AbsolutePath {return $Uri.AbsolutePath}
		Authority {return $Uri.Authority}
		Credentials {return ConvertFrom-UserInfo $Uri.UserInfo}
		Extension {return Split-Path $Uri.LocalPath -Extension}
		Filename {switch -Wildcard ($Uri.Segments[-1]) { '*/' {return $Filename -f (Get-Date),(New-Guid)} default {return $_} }}
		HostNameType {return $Uri.HostNameType}
		IsAbsoluteUri {return $Uri.IsAbsoluteUri}
		IsDefaultPort {return $Uri.IsDefaultPort}
		IsFile {return $Uri.IsFile}
		IsLoopback {return $Uri.IsLoopback}
		IsUnc {return $Uri.IsUnc}
		Leaf {return $Uri.Segments[-1]}
		LeafBase {return Split-Path ($Uri.Segments[-1]) -LeafBase}
		ParentPath {return ($Uri.Segments |Select-Object -SkipLast 1) -join ''}
		ParentUri {return New-Object uri $Uri,(($Uri.Segments |Select-Object -SkipLast 1) -join '')}
		HostPart {return $Uri.Host}
		IdnHost {return $Uri.IdnHost}
		LocalPath {return $Uri.LocalPath}
		PathAndQuery {return $Uri.PathAndQuery}
		Port {return $Uri.Port}
		Query {return $Uri.Query}
		QueryAsDictionary {return ConvertFrom-QueryString $Uri.Query}
		Scheme {return $Uri.Scheme}
		Segment {return $Uri.Segments[$Segment]}
	}
}
