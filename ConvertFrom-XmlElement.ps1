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
if(($Element.SelectNodes('*') |group Name |measure).Count -eq 1)
{
    @($Element.SelectNodes('*') |% {ConvertFrom-XmlElement.ps1 $_})
}
else
{
    $properties = @{}
    $Element.Attributes |% {[void]$properties.Add($_.Name,$_.Value)}
    foreach($node in $Element.ChildNodes |? {$_.Name -and $_.Name -ne '#whitespace'})
    {
        $subelements = $node.SelectNodes('*') |group Name
        $value = 
            if($node.InnerText -and !$subelements)
            {
                $node.InnerText
            }
            elseif(($subelements |measure).Count -eq 1)
            {
                @($node.SelectNodes('*') |% {ConvertFrom-XmlElement.ps1 $_})
            }
            else
            {
                ConvertFrom-XmlElement.ps1 $node
            }
        if(!$properties.Contains($node.Name))
        { # new property
            [void]$properties.Add($node.Name,$value)
        }
        else
        { # property name collision!
            if($properties[$node.Name] -isnot [Collections.Generic.List[object]])
            { $properties[$node.Name] = ([Collections.Generic.List[object]]@($properties[$node.Name],$value)) }
            else
            { $properties[$node.Name].Add($value) }
        }
    }
    New-Object PSObject -Property $properties
}
