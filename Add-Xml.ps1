<#
.Synopsis
    Insert XML into an XML document relative to a node found by Select-Xml.

.Parameter Xml
    The XML node(s) to insert.

.Parameter Position
    Where to insert the new node(s), relative to the node found by Select-Xml.

    * AppendChild: At the end of the node's children. This is the default.
    * InsertAfter: Following the node.
    * InsertBefore: Preceding the node.
    * PrependChild: At the beginning of the node's children.

.Parameter UnlessXPath
    An XPath, rooted from the node found by Select-Xml, that will cancel the insert if it exists.
    Used to prevent inserting XML already in the document.

.Parameter Namespace
    Specifies a hash table of the namespaces used in UnlessXPath.
    Use the format @{prefix = 'uri'}.

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
    Select-Xml /configuration/appSettings app.config |Add-Xml.ps1 '<add key="Version" value="2.0"/>' -UnlessXPath 'add[@key="Version"]'

    (Adds element to document file if it is not already there.)
#>

[CmdletBinding()][OutputType([xml])] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('Node','Element')][xml[]]$Xml,
[ValidateSet('AppendChild','InsertAfter','InsertBefore','PrependChild')][string]$Position = 'AppendChild',
[Parameter(Position=1)][Alias('IfMissing')][string]$UnlessXPath,
[Parameter(Position=2)][Hashtable]$Namespace,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.PowerShell.Commands.SelectXmlInfo]$SelectXmlInfo
)
Process
{
    [Xml.XmlNode]$node = $SelectXmlInfo.Node
    if(!$node.ParentNode -and $Position -in 'InsertAfter','InsertBefore')
    {
        Stop-ThrowError.ps1 [ArgumentException] "Unable to $Position root node",
            SelectXmlInfo InvalidArgument $SelectXmlInfo SingleRoot
    }
    $ns = if($Namespace){@{Namespace=$Namespace}}else{@{}}
    if($UnlessXPath -and (Select-Xml $UnlessXPath $node @ns)) { Write-Verbose "Found $UnlessXPath in $($SelectXmlInfo.Pattern)"; return }
    [xml]$doc = $node.OwnerDocument

    foreach($adddoc in $Xml)
    {
        [Xml.XmlNode[]]$addnodes = $adddoc.ChildNodes
        if($Position -in 'InsertAfter','PrependChild') {[Array]::Reverse($addnodes)}
        foreach($addnode in ($addnodes |% {$doc.ImportNode($_,$true)}))
        {
            Write-Verbose "$Position $($addnode.OuterXml) to $($SelectXmlInfo.Pattern)"
            switch($Position)
            {
                AppendChild  {[void]$node.AppendChild($addnode)}
                InsertAfter  {[void]$node.ParentNode.InsertAfter($addnode,$node)}
                InsertBefore {[void]$node.ParentNode.InsertBefore($addnode,$node)}
                PrependChild {[void]$node.PrependChild($addnode)}
            }
        }
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
