<#
.SYNOPSIS
Gets the namespaces from a document as a dictionary.

.OUTPUTS
System.Collections.Generic.Dictionary[System.String,System.String] containing namespace
prefixes as keys and namespace URIs as values.

.FUNCTIONALITY
XML

.LINK
https://stackoverflow.com/a/26786080/54323

.EXAMPLE
Select-Xml /xsl:transform .\dataref.xslt -Namespace (Get-XmlNamespaces.ps1 .\dataref.xslt)

Node      Path                                       Pattern
----      ----                                       -------
transform C:\Users\brian\GitHub\scripts\dataref.xslt /xsl:transform

.EXAMPLE
Get-XmlNamespaces.ps1 .\dataref.xslt

Key     Value
---     -----
xml     http://www.w3.org/XML/1998/namespace
xsl     http://www.w3.org/1999/XSL/Transform
xs      http://www.w3.org/2001/XMLSchema
x       urn:guid:f203a737-cebb-419d-9fbe-a684f1f13591
wsdl    http://schemas.xmlsoap.org/wsdl/
        http://www.w3.org/1999/xhtml
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Collections.Generic.Dictionary[string,string]])] Param(
# The XML file.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string]$Path
)
Process
{
    $doc = [xml](Get-Content $Path -Raw)
    $nav = $doc.DocumentElement.CreateNavigator()
    [void]$nav.MoveToFollowing('Element')
    $nav.GetNamespacesInScope('All')
}
