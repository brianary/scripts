<#
.SYNOPSIS
Gets the namespaces and their URIs and URLs from a document.

.INPUTS
System.Xml.XmlDocument or System.String containing the path to an XML file.

.OUTPUTS
System.Management.Automation.PSCustomObject for each namespace, with Path,
Node, Alias, Urn, and Url properties.

.FUNCTIONALITY
XML

.LINK
https://www.w3.org/TR/xmlschema-1/#schema-loc

.LINK
https://stackoverflow.com/a/26786080/54323

.EXAMPLE
Resolve-XmlSchemaLocation.ps1 test.xml

Path  : C:\test.xml
Node  : root
Alias : xml
Urn   : http://www.w3.org/XML/1998/namespace
Url   :

Path  : C:\test.xml
Node  : root
Alias : xsi
Urn   : http://www.w3.org/2001/XMLSchema-instance
Url   :
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
# The string to check.
[Parameter(ParameterSetName='Xml',Position=0,Mandatory=$true,ValueFromPipeline=$true)][xml] $Xml,
# A file to check.
[Parameter(ParameterSetName='Path',Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][ValidateScript({Test-Path $_ -PathType Leaf})][string] $Path
)
Process
{
	$xmlsrc = if($Path) {@{Path=$Path}} else {@{Xml=$Xml}}
	foreach($element in (Select-Xml '//*[@xsi:schemaLocation]' @xmlsrc -Namespace @{
		xsi='http://www.w3.org/2001/XMLSchema-instance'} |% Node))
	{
		$nonsatt = $element.Attributes.GetNamedItem('noNamespaceSchemaLocation',
			'http://www.w3.org/2001/XMLSchema-instance')
		$nons = if($nonsatt) {$nonsatt.Value}
		[string[]]$locations = $element.Attributes.GetNamedItem('schemaLocation',
			'http://www.w3.org/2001/XMLSchema-instance').Value.Trim() -split '\s+'
		if($locations.Length -band 1) {Write-Warning "XML schemaLocation has $($locations.Length) entries"}
		$schemaLocation = @{}
		for($i = 1; $i -lt $locations.Length; $i += 2)
		{
			$schemaLocation[$locations[$i-1]] = $locations[$i]
		}
		$nav = $element.CreateNavigator()
		[void]$nav.MoveToFollowing('Element')
		$ns = $nav.GetNamespacesInScope('All')
		foreach($ns in $ns.GetEnumerator())
		{
			[pscustomobject]@{
				Path  = $Path
				Node  = $element
				Alias = $ns.Key
				Urn   = $ns.Value
				Url   = if($schemaLocation.ContainsKey($ns.Value)) {$schemaLocation[$ns.Value]} else {$nons}
			}
		}
	}
}
