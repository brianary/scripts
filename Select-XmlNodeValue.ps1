<#
.Synopsis
    Returns the value of an XML node found by Select-Xml.

.Parameter SelectXmlInfo
    Output from the Select-Xml cmdlet.

.Link
    Select-Xml

.Example
    Select-Xml /error/@message \\server\apps\appname\App_Data\Elmah.Errors\guid.xml |Select-XmlNodeValue.ps1


    Object reference not set to an instance of an object.

.Example
    Select-Xml //xs:element/@name schema.xsd -Namespace @{ xs = 'http://www.w3.org/2001/XMLSchema' } |Select-XmlNodeValue.ps1


    elementName1
    elementName2
    …
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.PowerShell.Commands.SelectXmlInfo]$SelectXmlInfo
)
Process
{
    [Xml.XmlNode]$node = $SelectXmlInfo.Node
    if($node.NodeType -eq 'Element')
    {
        $node.InnerText
    }
    elseif($node.NodeType -in 'Document','DocumentFragment','DocumentType','Entity','EntityReference','Notation')
    {
        Write-Warning "Cannot get value for $($node.NodeType) node."
    }
    else
    {
        $node.Value
    }
}
