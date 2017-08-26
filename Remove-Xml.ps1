<#
.Synopsis
    Removes a node found by Select-Xml from its XML document.

.Parameter SelectXmlInfo
    Output from the Select-Xml cmdlet.

.Inputs
    Microsoft.PowerShell.Commands.SelectXmlInfo, the output from Select-Xml.

.Outputs
    System.Xml.XmlDocument
    Returned when Select-Xml queries an in-memory XML document or string, null when querying a file.

.Link
    Select-Xml

.Example
    Select-Xml '/configuration/appSettings/add[@key="Version"]' app.config |Remove-Xml.ps1

    (Removes the specified node from the file.)
#>

[CmdletBinding()][OutputType([xml])] Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.PowerShell.Commands.SelectXmlInfo]$SelectXmlInfo
)
Process
{
    [Xml.XmlNode]$node = $SelectXmlInfo.Node
    [xml]$doc = $node.OwnerDocument
    Write-Verbose "Removing $($node.OuterXml)"

    if($node.ParentNode -eq $null) {throw 'Unable to remove root node.'}
    [void]$node.ParentNode.RemoveChild($node)

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
