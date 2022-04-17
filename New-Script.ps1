<#
.SYNOPSIS
Creates a simple boilerplate script.

.PARAMETER NameVerb
The verb prefix name of the script, e.g. Get or Update or Add.

.PARAMETER NameNoun
The noun part of the name of the script.

.PARAMETER Synopsis
A one-line description of the purpose of the script.

.PARAMETER Parameters
A runtime parameter dictionary $DynamicParams created via Add-DynamicParam.ps1

.PARAMETER Inputs
Documentation about the datatype accepted as pipeline input by the script.

.PARAMETER Outputs
Documentation about the datatype produced as output by the script.

.PARAMETER DynamicParam
The DynamicParam script block.

.PARAMETER OutputType
The return type of the script.

.PARAMETER Links
A list of script documentation references to link to (URLs and cmdlet names).

.PARAMETER Example
A list of example commands to add to the script documentation.

.PARAMETER Begin
The Begin script block.

.PARAMETER Process
The Process (main) script block.

.PARAMETER End
The End script block.

.PARAMETER RequiresVersion
The minimum PowerShell version required for the script.

.PARAMETER RequiresModule
A module required by the script.

.PARAMETER ConfirmImpact
The potential risk of the script: High, Medium, or Low.

.PARAMETER DefaultParameterSetName
The name of the default parameter set.

.PARAMETER HelpUri
A URL for online help.

.PARAMETER Indent
The indent string to use.

.PARAMETER RequiresRunAsAdmin
Indicates that the script must be run as an Administrator.

.PARAMETER SupportsPaging
Indicates that the script supports paged output.

.PARAMETER SupportsShouldProcess
Indicates that the script supports confirmation prompting and -WhatIf.

.PARAMETER PositionalBinding
Indicates that the script supports positional parameter binding.

.EXAMPLE
New-Script.ps1 Add Xml -Synopsis 'Insert XML...' -OutputType xml

Creates a basic script.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
[Parameter(Position=1,Mandatory=$true)][string] $NameNoun,
[string] $Synopsis,
[Management.Automation.RuntimeDefinedParameterDictionary] $Parameters,
[string] $Inputs,
[string] $Outputs,
[ScriptBlock] $DynamicParam,
[type] $OutputType,
[string[]] $Links,
[string[]] $Example,
[ScriptBlock] $Begin,
[ScriptBlock] $Process,
[ScriptBlock] $End,
[decimal] $RequiresVersion = 3,
[string[]] $RequiresModule,
[ValidateSet('High','Medium','Low')][string] $ConfirmImpact,
[string] $DefaultParameterSetName,
[uri] $HelpUri,
[string] $Indent = "`t",
[Alias('RequiresAdmin','Admin')][switch] $RequiresRunAsAdmin,
[switch] $SupportsPaging,
[switch] $SupportsShouldProcess,
[switch] $PositionalBinding
)
DynamicParam
{
    Get-Verb |foreach Verb |Add-DynamicParam.ps1 NameVerb string -Position 0 -Mandatory
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
    if($Parameters -and $Parameters.Count) {$commenthelp += $Parameters.GetEnumerator() |% Key |% {".Parameter $_",''}}
    if($Inputs) {$commenthelp += '.Inputs',"$Indent$Inputs",''}
    if($Outputs) {$commenthelp += '.Outputs',"$Indent$Outputs",''}
    if($Links) {$commenthelp += $Links |% {'.Link',"$Indent$_",''}}
    if($Example) {$commenthelp += $Example |% {'.Example',"$Indent$_",''}}
    $requires = @()
    $reqver = if($RequiresVersion -eq [decimal][int]$RequiresVersion){[int]$RequiresVersion}else{$RequiresVersion}
    $requires += "#Requires -Version $reqver"
    if($RequiresRunAsAdmin) {$requires += '#Requires -RunAsAdministrator'}
    if($RequiresModule -and $RequiresModule.Count) {$requires += $RequiresModule |% {"#Requires -Module $_"}}
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
