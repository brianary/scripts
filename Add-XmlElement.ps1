<#
.Synopsis
    Insert an XML element into an XML document as a child of a node found by Select-Xml.

.Parameter XmlElement
    The XML element to insert.

.Parameter SelectXmlInfo
    Output from the Select-Xml cmdlet.

.Link
    Select-Xml

.Example
    Select-Xml /configuration/appSettings app.config |Add-XmlElement.ps1 '<add key="Version" value="2.0"/>' -UnlessXPath 'add[@key="Version"]'


    (Adds element to document file if it is not already there.)
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('Element')][xml[]]$XmlElement,
[Parameter(Position=1)][Alias('IfMissing')][string]$UnlessXPath,
[Parameter(Position=2)][Hashtable]$Namespace,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.PowerShell.Commands.SelectXmlInfo]$SelectXmlInfo
)
Process
{
    if($SelectXmlInfo.Node.NodeType -ne 'Element')
    {throw "Node at '$($SelectXmlInfo.Pattern)' is '$($SelectXmlInfo.Node.NodeType)', not 'Element'."}
    [Xml.XmlElement]$node = $SelectXmlInfo.Node
    if(!$node) {throw "Could not locate $XPath to append child"}
    if($UnlessXPath -and (Select-Xml $UnlessXPath $node)) { Write-Verbose "Found $UnlessXPath in $($SelectXmlInfo.Pattern)"; return }
    [xml]$doc = $node.OwnerDocument

    foreach($element in ($XmlElement |% DocumentElement))
    {
        Write-Verbose "Appending $($element.OuterXml) as child of $XPath"
        [void]$node.AppendChild($doc.ImportNode($element,$true))
    }

    if($SelectXmlInfo.Path -and $SelectXmlInfo.Path -ne 'InputStream')
    {
        $file = $SelectXmlInfo.Path
        Write-Verbose "Saving '$file'"
        $xw = New-Object Xml.XmlTextWriter $file,([Text.Encoding]::UTF8)
        $doc.Save($xw)
        $xw.Dispose()
        $xw = $null
    }
    elseif($Content)
    {
        $doc.OuterXml
    }
    else
    {
        $doc
    }
}
