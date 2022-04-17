<#
.SYNOPSIS
Escape URLs more aggressively.

.DESCRIPTION
Some characters such as apostrophes and parentheses are legal for URLs,
but are a hassle within certain formats (Markdown, JSON, SQL, &c).

This script URL-escapes these characters to %xx format.

.PARAMETER Uri
The URL to format for maximum compatibility.

.PARAMETER Clipboard
Indicates that the URL comes from the clipboard, and is updated on the clipboard.

.INPUTS
System.Uri to escape.

.OUTPUTS
System.String containing the URL escaped for maximum compatibility.

.EXAMPLE
Format-EscapedUrl.ps1 -Clipboard

Updates the URL on the clipboard with a more aggressively escaped version.

.EXAMPLE
Format-EscapedUrl.ps1 "https://example.com/search(en-US)?q=Name%20%3D%20'System'&sort=y"

https://example.com/search%28en-US%29?q=Name%20%3D%20%27System%27&sort=y
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(ParameterSetName='Uri',Position=0,ValueFromPipeline=$true,ValueFromRemainingArguments=$true,Mandatory=$true)]
[Alias('Url')][uri[]]$Uri,
[Parameter(ParameterSetName='Clipboard')][switch]$Clipboard
)
Begin
{
    [char[]]$chars = ' ',"'",'(',')','[',']','$'
}
Process
{
    if($Clipboard) {Get-Clipboard |Format-EscapedUrl.ps1 |Set-Clipboard}
    else
    {
        foreach($u in $Uri)
        {
            $escaped = if($u.IsAbsoluteUri){$u.AbsoluteUri}else{$u.OriginalString}
            foreach($c in $chars) {$escaped = $escaped.Replace([string]$c,('%{0:X2}' -f [int]$c))}
            $escaped
        }
    }
}
