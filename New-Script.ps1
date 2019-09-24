<#
.Synopsis
    Creates a simple boilerplate script.

.Parameter NameVerb
    The verb prefix name of the script, e.g. Get or Update or Add.

.Parameter NameNoun
    The noun part of the name of the script.

.Parameter Synopsis
    A one-line description of the purpose of the script.

.Parameter Parameters
    A runtime parameter dictionary $DynamicParams created via Add-DynamicParam.ps1

.Parameter Inputs
    Documentation about the datatype accepted as pipeline input by the script.

.Parameter Outputs
    Documentation about the datatype produced as output by the script.

.Parameter DynamicParam
    The DynamicParam script block.

.Parameter OutputType
    The return type of the script.

.Parameter Links
    A list of script documentation references to link to (URLs and cmdlet names).

.Parameter Example
    A list of example commands to add to the script documentation.

.Parameter Begin
    The Begin script block.

.Parameter Process
    The Process (main) script block.

.Parameter End
    The End script block.

.Parameter RequiresVersion
    The minimum PowerShell version required for the script.

.Parameter RequiresModule
    A module required by the script.

.Parameter ConfirmImpact
    The potential risk of the script: High, Medium, or Low.

.Parameter DefaultParameterSetName
    The name of the default parameter set.

.Parameter HelpUri
    A URL for online help.

.Parameter Indent
    The indent string to use.

.Parameter RequiresRunAsAdmin
    Indicates that the script must be run as an Administrator.

.Parameter SupportsPaging
    Indicates that the script supports paged output.

.Parameter SupportsShouldProcess
    Indicates that the script supports confirmation prompting and -WhatIf.

.Parameter PositionalBinding
    Indicates that the script supports positional parameter binding.

.Example
    New-Script.ps1 Add Xml -Synopsis 'Insert XML...' -OutputType xml

    Creates a basic script.
#>

#Requires -Version 3
[CmdletBinding()] Param(
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
    Add-DynamicParam.ps1 NameVerb string -Position 0 -Mandatory -ValidateSet (Get-Verb |% Verb)
    $DynamicParams
}
Process
{
    $OFS = @'


'@
    $name = "$Verb-$Noun.ps1"
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
    if($Parameters -and $Parameters.Count) {$params = $Parameters |Format-PSLiterals.ps1}
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
