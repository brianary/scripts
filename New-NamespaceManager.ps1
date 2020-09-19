<#
.Synopsis
	Creates an object to lookup XML namespace prefixes.

.Parameter Namespaces
	A dictionary of prefixes and their namespace URLs.
	If a default Namespace value for Select-Xml exists, this will use it.

.Outputs
	System.Xml.XmlNamespaceManager containing the given namespaces.

.Link
	https://docs.microsoft.com/dotnet/api/system.xml.xmlnamespacemanager

.Example
	Use-ReasonableDefaults.ps1; $n = New-NamespaceManager.ps1; (Select-Xml //xhtml:td dataref.xslt).Node.SelectSingleNode('xhtml:var',$n).OuterXml

	<var xmlns="http://www.w3.org/1999/xhtml">ANY</var>
	<var xmlns="http://www.w3.org/1999/xhtml">ANY</var>
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Xml.XmlNamespaceManager])] Param(
[ValidateNotNullOrEmpty()][Collections.IDictionary] $Namespaces = $PSDefaultParameterValues['Select-Xml:Namespace']
)
$value = New-Object Xml.XmlNamespaceManager (New-Object Xml.NameTable)
foreach($ns in $Namespaces.GetEnumerator())
{
	$value.AddNamespace($ns.Name,$ns.Value)
}
return,$value
