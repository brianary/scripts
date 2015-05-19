<#
.Synopsis
Converts named nodes of an element to properties of a PSObject, recursively.
.Parameter Element
The element to convert to a PSObject.
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Xml.XmlElement] $Element
)
if(1 -eq ($Element.SelectNodes('*') |group Name |measure |% Count))
{
    @($Element.SelectNodes('*') |% {ConvertFrom-XmlElement.ps1 $_})
}
else
{
    $properties = @{}
    foreach($node in $Element.ChildNodes |? {$_.Name -and $_.Name -ne '#whitespace'})
    {
        $subelements = $node.SelectNodes('*') |group Name
        $value = 
            if(!$subelements)
            {
                $node.InnerText
            }
            elseif(1 -eq ($subelements |measure |% Count))
            {
                @($node.SelectNodes('*') |% {ConvertFrom-XmlElement.ps1 $_})
            }
            else
            {
                ConvertFrom-XmlElement.ps1 $node
            }
        [void]$properties.Add($node.Name,$value)
    }
    New-Object PSObject -Property $properties
}
