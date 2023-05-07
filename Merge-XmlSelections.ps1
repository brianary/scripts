<#
.SYNOPSIS
Builds an object using the named XPath selections as properties.

.INPUTS
System.Xml.XmlNode of XML or System.String of XML file names to select property values from.

.OUTPUTS
System.Management.Automation.PSCustomObject object with the selected properties.

.FUNCTIONALITY
XML

.LINK
https://github.com/brianary/Detextive/

.EXAMPLE
Merge-XmlSelections.ps1 @{Version='/*/@version';Format='/xsl:output/@method'} *.xsl* -Namespace @{xsl='http://www.w3.org/1999/XSL/Transform'}

Path                    Version Format
----                    ------- ------
Z:\Scripts\dataref.xslt 2.0     html
Z:\Scripts\xhtml2fo.xsl 1.0     xml
#>

#Requires -Version 3
#Requires -Modules SelectXmlExtensions
[CmdletBinding()][OutputType([psobject])] Param(
# Any dictionary or hashtable of property name to XPath to select a value with.
[Parameter(Position=0,Mandatory=$true)][Collections.IDictionary] $XPaths,
# The XML to select the property values from.
[Parameter(ParameterSetName='Xml',Position=1,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[Xml.XmlNode[]] $Xml,
# XML file(s) to select the property values from.
[Parameter(ParameterSetName='Path',Position=1,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string[]] $Path,
# XML namespaces to use in the XPath expressions.
[hashtable] $Namespace = $PSDefaultParameterValues['Select-Xml:Namespace']
)
Process
{
	$ns = if($Namespace -and $Namespace.Count) {@{Namespace=$Namespace}} else {@{}}
	if($PSCmdlet.ParameterSetName -eq 'Xml')
	{
		foreach($x in $Xml)
		{
			$value = [ordered]@{Path='InputStream';Xml=$x.OwnerDocument}
			foreach($prop in $XPaths.GetEnumerator())
			{
				$value.Add($prop.Key,($x |Select-Xml $prop.Value @ns |Get-XmlValue))
			}
			[pscustomobject]$value
		}
	}
	else
	{
		foreach($f in $Path |Resolve-Path)
		{
			$value = [ordered]@{Path=$f}
			foreach($prop in $XPaths.GetEnumerator())
			{
				$value.Add($prop.Key,(Select-Xml $prop.Value -Path $f @ns |Get-XmlValue))
			}
			[pscustomobject]$value
		}
	}
}
