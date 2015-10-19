<#
.Synopsis
    Try parsing text as XML.

.Parameter Xml
    The string to check.

.Parameter Path
    A file to check.

.Parameter ErrorMessage
    Instead of a boolean value, returns the parse error message, or nothing if successful.
#>

[CmdletBinding()] Param(
[Parameter(ParameterSetName='Xml',Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[ValidateScript({!(Test-Path $_ -PathType Leaf)})][string] $Xml,
[Parameter(ParameterSetName='Path',Mandatory=$true,ValueFromPipeline=$true)]
[ValidateScript({Test-Path $_ -PathType Leaf})][string] $Path,
[switch]$ErrorMessage
)
if($Path){$Xml= Get-Content $Path -Raw}
try{[void][xml]$Xml; return $(if(!$ErrorMessage){$true})}
catch [Management.Automation.RuntimeException]
{
    if(!$ErrorMessage){return $false}
    else{return $_.Exception.InnerException.InnerException.Message}
}