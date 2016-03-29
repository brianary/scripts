<#
.Synopsis
    Serializes complex content into XML elements.

.Parameter Value
    A hash or XML element or other object to be serialized as XML elements.

    Each hash value or object property value may itself be a hash or object or XML element.

.Example
    Format-XmlElements.ps1 @{html=@{body=@{p='Some text.'}}}


    <html><body><p>Some text.</p></body></html>

.Example
    New-Object psobject -Property @{UserName=$env:USERNAME;Computer=$env:COMPUTERNAME} |Format-XmlElements.ps1


    <Computer>COMPUTERNAME</Computer>
    <UserName>username</UserName>

.Example
    Get-ChildItem *.txt |Format-XmlElements.ps1


    <PSPath>Microsoft.PowerShell.Core\FileSystem::C:\temp\test.txt</PSPath>
    <PSParentPath>Microsoft.PowerShell.Core\FileSystem::C:\scripts</PSParentPath>
    <PSChildName>test.txt</PSChildName>
    <PSDrive></PSDrive>
    <PSProvider></PSProvider>
    <VersionInfo><FileVersionRaw></FileVersionRaw>
    <ProductVersionRaw></ProductVersionRaw>
    …
#>

#requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,ValueFromPipeline=$true)]$Value
)
Begin {$Script:OFS = "`n"}
Process
{
    if($Value -eq $null) {}
    elseif($Value -is [int])
    { "$Value" }
    elseif($Value -is [string])
    { [Net.WebUtility]::HtmlEncode($Value) }
    elseif($Value -is [datetime])
    { '{0:yyyy-MM-dd\THH:mm:ss}' -f $Value }
    elseif($Value -is [PSObject])
    {
        $Value.PSObject.Properties |
            ? {$_.Name -match '^\w+$'} |
            % {"<$($_.Name)>$(Format-XmlElements.ps1 $_.Value)</$($_.Name)>"}
    }
    elseif($Value -is [Hashtable] -or $Value -is [Collections.Specialized.OrderedDictionary])
    { $Value.Keys |? {$_ -match '^\w+$'} |% {"<$_>$(Format-XmlElements.ps1 $Value.$_)</$_>"} }
    elseif($Value -is [xml])
    { $Value.OuterXml }
    else
    {
        Get-Member -InputObject $Value.PSObject.Properties -MemberType Properties |
            ? {$_.Name -match '^\w+$'} |
            % {"<$($_.Name)>$(Format-XmlElements.ps1 $Value.$($_.Value))</$($_.Name)>"}
    }
}