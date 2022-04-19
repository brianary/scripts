<#
.SYNOPSIS
Adds an XML attribute to an XML element found by Select-Xml.

.INPUTS
Microsoft.PowerShell.Commands.SelectXmlInfo, the output from Select-Xml.

.OUTPUTS
System.Xml.XmlDocument
Returned when Select-Xml queries an in-memory XML document or string, null when querying a file.

.LINK
Select-Xml

.EXAMPLE
Select-Xml /configuration/system.web/compilation web.config |Set-XmlAttribute.ps1 debug false

(Adds or updates the value of the 'debug' attribute to 'false'.)
#>

[CmdletBinding()][OutputType([xml])] Param(
# The name of the new attribute.
[Parameter(Position=0,Mandatory=$true)][string]$Name,
# The value of the new attribute.
[Parameter(Position=1,Mandatory=$true)][string]$Value,
# The URI of the namespace of the new attribute, if needed.
[Parameter(Position=2)][string]$NamespaceUri,
# Output from the Select-Xml cmdlet.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.PowerShell.Commands.SelectXmlInfo]$SelectXmlInfo
)
Process
{
    if($SelectXmlInfo.Node.NodeType -ne 'Element')
    {throw "Node at '$($SelectXmlInfo.Pattern)' is '$($SelectXmlInfo.Node.NodeType)', not 'Element'."}
    [Xml.XmlElement]$node = $SelectXmlInfo.Node
    [xml]$doc = $node.OwnerDocument

    if($NamespaceUri) { [void]$node.SetAttribute($Name,$NamespaceUri,$Value) }
    else { [void]$node.SetAttribute($Name,$Value) }

    if($SelectXmlInfo.Path -and $SelectXmlInfo.Path -ne 'InputStream')
    {
        $file = $SelectXmlInfo.Path
        Write-Verbose "Saving '$file'"
        $xw = New-Object Xml.XmlTextWriter $file,([Text.Encoding]::UTF8)
        $doc.Save($xw)
        $xw.Dispose()
        $xw = $null
    }
    else
    {
        $doc
    }
}
