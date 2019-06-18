<#
.Synopsis
    Gets the namespaces and their URIs and URLs from a document.

.Link
    https://www.w3.org/TR/xmlschema-1/#schema-loc

.Link
    https://stackoverflow.com/a/26786080/54323

.Example
    Resolve-XmlNamespaces.ps1 test.xml

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
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string]$Path
)
Process
{
    foreach($element in (Select-Xml '//*[@xsi:schemaLocation]' $Path -Namespace @{
        xsi='http://www.w3.org/2001/XMLSchema-instance'} |% Node))
    {
        $nonsatt = $element.Attributes.GetNamedItem('noNamespaceSchemaLocation',
            'http://www.w3.org/2001/XMLSchema-instance')
        $nons = if($nonsatt) {$nonsatt.Value}
        [string[]]$locations = $element.Attributes.GetNamedItem('schemaLocation',
            'http://www.w3.org/2001/XMLSchema-instance').Value -split '\s+'
        $schemaLocation = @{}
        for($i = 0; $i -lt $locations.Length; $i += 2)
        {
            $schemaLocation[$locations[$i]] = $locations[$i+1]
        }
        $nav = $element.CreateNavigator()
        [void]$nav.MoveToFollowing('Element')
        $ns = $nav.GetNamespacesInScope('All')
        foreach($ns in $ns.GetEnumerator())
        {
            [pscustomobject]@{
                Path = $Path
                Node = $element
                Alias = $ns.Key
                Urn   = $ns.Value
                Url   = if($schemaLocation.ContainsKey($ns.Value)) {$schemaLocation[$ns.Value]} else {$nons}
            }
        }
    }
}
