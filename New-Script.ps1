<#
.SYNOPSIS
Creates a simple boilerplate script.

.PARAMETER NameVerb
The verb prefix name of the script, e.g. Get or Update or Add.

.FUNCTIONALITY
Scripts

.EXAMPLE
New-Script.ps1 Add Xml -Synopsis 'Insert XML...' -OutputType xml

Creates a basic script.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# The noun part of the name of the script.
[Parameter(Position=1,Mandatory=$true)][string] $NameNoun,
# A one-line description of the purpose of the script.
[string] $Synopsis,
# A runtime parameter dictionary $DynamicParams created via Add-DynamicParam.ps1
[Management.Automation.RuntimeDefinedParameterDictionary] $Parameters,
# Documentation about the datatype accepted as pipeline input by the script.
[string] $Inputs,
# Documentation about the datatype produced as output by the script.
[string] $Outputs,
# The DynamicParam script block.
[ScriptBlock] $DynamicParam,
# The return type of the script.
[type] $OutputType,
# A list of script documentation references to link to (URLs and cmdlet names).
[string[]] $Links,
# A list of example commands to add to the script documentation.
[string[]] $Example,
# The Begin script block.
[ScriptBlock] $Begin,
# The Process (main) script block.
[ScriptBlock] $Process,
# The End script block.
[ScriptBlock] $End,
# The minimum PowerShell version required for the script.
[decimal] $RequiresVersion = 3,
# A module required by the script.
[string[]] $RequiresModule,
# The potential risk of the script: High, Medium, or Low.
[ValidateSet('High','Medium','Low')][string] $ConfirmImpact,
# The name of the default parameter set.
[string] $DefaultParameterSetName,
# A URL for online help.
[uri] $HelpUri,
# The indent string to use.
[string] $Indent = "`t",
# Indicates that the script must be run as an Administrator.
[Alias('RequiresAdmin','Admin')][switch] $RequiresRunAsAdmin,
# Indicates that the script supports paged output.
[switch] $SupportsPaging,
# Indicates that the script supports confirmation prompting and -WhatIf.
[switch] $SupportsShouldProcess,
# Indicates that the script supports positional parameter binding.
[switch] $PositionalBinding
)
DynamicParam
{
    Get-Verb |Select-Object -ExpandProperty Verb |Add-DynamicParam.ps1 NameVerb string -Position 0 -Mandatory
    $DynamicParams
}
Process
{
    Import-Variables.ps1 $PSBoundParameters
    $OFS = @'


'@
    $name = "$NameVerb-$NameNoun.ps1"
    $commenthelp = @()
    if($Synopsis) {$commenthelp += '.Synopsis',"$Indent$Synopsis",''}
    if($Parameters -and $Parameters.Count) {$commenthelp += $Parameters.GetEnumerator() |Select-Object -ExpandProperty Key |ForEach-Object {".Parameter $_",''}}
    if($Inputs) {$commenthelp += '.Inputs',"$Indent$Inputs",''}
    if($Outputs) {$commenthelp += '.Outputs',"$Indent$Outputs",''}
    if($Links) {$commenthelp += $Links |ForEach-Object {'.Link',"$Indent$_",''}}
    if($Example) {$commenthelp += $Example |ForEach-Object {'.Example',"$Indent$_",''}}
    $requires = @()
    $reqver = if($RequiresVersion -eq [decimal][int]$RequiresVersion){[int]$RequiresVersion}else{$RequiresVersion}
    $requires += "#Requires -Version $reqver"
    if($RequiresRunAsAdmin) {$requires += '#Requires -RunAsAdministrator'}
    if($RequiresModule -and $RequiresModule.Count) {$requires += $RequiresModule |ForEach-Object {"#Requires -Module $_"}}
    $cmdletbinding = @()
    if($ConfirmImpact) {$cmdletbinding += "ConfirmImpact=$ConfirmImpact"}
    if($DefaultParameterSetName) {$cmdletbinding += "DefaultParameterSetName=$DefaultParameterSetName"}
    if($HelpUri) {$cmdletbinding += "HelpURI=$HelpUri"}
    if($SupportsPaging) {$cmdletbinding += "SupportsPaging=$SupportsPaging"}
    if($SupportsShouldProcess) {$cmdletbinding += "SupportsShouldProcess=$SupportsShouldProcess"}
    if($PositionalBinding) {$cmdletbinding += "PositionalBinding=$PositionalBinding"}
    $outtype = if($OutputType) {"[OutputType([$OutputType])]"} else {''}
    if($Parameters -and $Parameters.Count) {$params = $Parameters |ConvertTo-PowerShell.ps1}
    $blocks = @()
    if($DynamicParam) {$blocks += 'DynamicParam','{',"$Indent$DynamicParam",'}'}
    if($Begin) {$blocks += 'Begin','{',"$Indent$Begin",'}'}
    if($Process) {$blocks += 'Process','{',"$Indent$Process",'}'}
    if($End) {$blocks += 'End','{',"$Indent$End",'}'}
@"
<#
$commenthelp
#>

$requires
[CmdletBinding($($cmdletbinding -join ','))]$outtype $params
$blocks
"@ |Out-File $name utf8
}
