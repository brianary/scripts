<#
.SYNOPSIS
Pretty-print XML.

.PARAMETER Xml
The XML string or document to format.

.PARAMETER IndentChar
A whitespace indent character to use, space by default.

.PARAMETER Indentation
The number of IndentChars to use per level of indent, 2 by default.
Set to zero for no indentation.

.PARAMETER NewLineOnAttributes
Indicates attributes should be written on a new line.

.INPUTS
System.Xml.XmlDocument to serialize.

.OUTPUTS
System.String containing the serialized XML document with desired indents.

.EXAMPLE
Get-PSProvider alias |ConvertTo-Xml |Format-Xml.ps1

<Objects>
	<Object Type="System.Management.Automation.ProviderInfo">
		<Property Name="ImplementingType" Type="System.RuntimeType">Microsoft.PowerShell.Commands.AliasProvider</Property>
		<Property Name="HelpFile" Type="System.String">System.Management.Automation.dll-Help.xml</Property>
		<Property Name="Name" Type="System.String">Alias</Property>
		<Property Name="PSSnapIn" Type="System.Management.Automation.PSSnapInInfo">Microsoft.PowerShell.Core</Property>
		<Property Name="ModuleName" Type="System.String">Microsoft.PowerShell.Core</Property>
		<Property Name="Module" Type="System.Management.Automation.PSModuleInfo" />
		<Property Name="Description" Type="System.String"></Property>
		<Property Name="Capabilities" Type="System.Management.Automation.Provider.ProviderCapabilities">ShouldProcess</Property>
		<Property Name="Home" Type="System.String"></Property>
		<Property Name="Drives" Type="System.Collections.ObjectModel.Collection`1[System.Management.Automation.PSDriveInfo]">
		<Property Type="System.Management.Automation.PSDriveInfo">Alias</Property>
		</Property>
	</Object>
</Objects>

.EXAMPLE
Get-PSProvider alias |ConvertTo-Xml |Format-Xml.ps1 -NewLineOnAttributes

<Objects>
	<Object
	Type="System.Management.Automation.ProviderInfo">
	<Property
		Name="ImplementingType"
		Type="System.RuntimeType">Microsoft.PowerShell.Commands.AliasProvider</Property>
	<Property
		Name="HelpFile"
		Type="System.String">System.Management.Automation.dll-Help.xml</Property>
	<Property
		Name="Name"
		Type="System.String">Alias</Property>
	<Property
		Name="PSSnapIn"
		Type="System.Management.Automation.PSSnapInInfo">Microsoft.PowerShell.Core</Property>
	<Property
		Name="ModuleName"
		Type="System.String">Microsoft.PowerShell.Core</Property>
	<Property
		Name="Module"
		Type="System.Management.Automation.PSModuleInfo" />
	<Property
		Name="Description"
		Type="System.String"></Property>
	<Property
		Name="Capabilities"
		Type="System.Management.Automation.Provider.ProviderCapabilities">ShouldProcess</Property>
	<Property
		Name="Home"
		Type="System.String"></Property>
	<Property
		Name="Drives"
		Type="System.Collections.ObjectModel.Collection`1[System.Management.Automation.PSDriveInfo]">
		<Property
		Type="System.Management.Automation.PSDriveInfo">Alias</Property>
	</Property>
	</Object>
</Objects>
#>

[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][xml] $Xml,
[ValidatePattern('\s')][char] $IndentChar = ' ',
[int] $Indentation = 2,
[Alias('SplitAttributes','AttributesSeparated')][switch] $NewLineOnAttributes
)
Process
{
	[Xml.XmlWriterSettings] $cfg = New-Object Xml.XmlWriterSettings -Property @{
		Indent              = !!$Indentation
		IndentChars         = "$IndentChar" * $Indentation
		OmitXmlDeclaration  = $true
		NewLineOnAttributes = $NewLineOnAttributes
	}
	$sw = New-Object IO.StringWriter
	[Xml.XmlWriter] $xw = [Xml.XmlWriter]::Create($sw, $cfg)
	$Xml.WriteTo($xw)
	$xw.Dispose()
	$sw.ToString()
	$sw.Dispose()
}
