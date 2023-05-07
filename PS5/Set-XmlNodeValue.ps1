<#
.SYNOPSIS
Sets the value of a node found by Select-Xml.

.INPUTS
Microsoft.PowerShell.Commands.SelectXmlInfo, the output from Select-Xml.

.OUTPUTS
System.Xml.XmlDocument
Returned when Select-Xml queries an in-memory XML document or string, null when querying a file.

.LINK
Select-Xml

.EXAMPLE
Select-Xml '/configuration/appSettings/add[@key="Version"]/@value' app.config |Set-XmlNodeValue.ps1 '3.0'

(Sets attribute value to '3.0', if found.)
#>

[CmdletBinding()][OutputType([xml])] Param(
# The value to set.
[Parameter(Position=0,Mandatory=$true)]$Value,
# Output from the Select-Xml cmdlet.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.PowerShell.Commands.SelectXmlInfo]$SelectXmlInfo
)
Process
{
    [Xml.XmlNode]$node = $SelectXmlInfo.Node
    [xml]$doc = $node.OwnerDocument

    Write-Verbose "Setting $($node.OuterXml) in $($SelectXmlInfo.Pattern) to $Value"
    if($node.NodeType -eq 'Element')
    {
        [void]$node.RemoveAll()
        [void]$node.AppendChild($doc.CreateTextNode($Value))
    }
    elseif($node.NodeType -in 'Document','DocumentFragment','DocumentType','Entity','EntityReference','Notation')
    {
        Write-Warning "Cannot set value for $($node.NodeType) node."
    }
    else
    {
        $node.Value = $Value
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
    else
    {
        $doc
    }
}

