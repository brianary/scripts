<#
.SYNOPSIS
Imports characters by name as constants into the current scope.

.INPUTS
System.String containing a character name.

.FUNCTIONALITY
Unicode

.LINK
Add-ScopeLevel.ps1

.LINK
Get-UnicodeByName.ps1

.EXAMPLE
Import-CharConstants.ps1 NL :UP: HYPHEN-MINUS 'EN DASH' '&mdash;' '&copy;' -Scope Script

Creates constants in the context of the current script for the named characters.
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The control code abbreviation, Unicode name, HTML entity, or GitHub name of the character to create a constant for.
# "NL" will use the newline appropriate to the environment.
[Parameter(ParameterSetName='UseNames',Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)][string[]] $CharacterName,
# A dictionary that maps character variable name aliases to control code abbreviations, Unicode names, HTML entities,
# or GitHub names of characters.
[Parameter(ParameterSetName='UseAliases',Mandatory=$true)][hashtable] $Alias,
# The scope of the constant.
[string] $Scope = 'Local',
<#
Appends a U+FE0F VARIATION SELECTOR-16 suffix to the character, which suggests an emoji presentation
for characters that support both a simple text presentation as well as a color emoji-style one.
#>
[switch] $AsEmoji
)
Begin
{
    $level = $Scope |Add-ScopeLevel.ps1 |Add-ScopeLevel.ps1

    filter Add-CharacterConstant
    {
        [CmdletBinding()] Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][Alias('Key')][string] $Alias,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)][Alias('Value')][string] $CharacterName
        )
        $char = $CharacterName -eq 'NL' ? [Environment]::NewLine : (Get-UnicodeByName.ps1 -Name $CharacterName -AsEmoji:$AsEmoji)
        Set-Variable -Name ($Alias.Trim(':')) -Value $char -Scope $level -Option Constant -Description $CharacterName
    }
}
Process
{
    switch($PSCmdlet.ParameterSetName)
    {
        UseNames {$CharacterName |Add-CharacterConstant}
        UseAliases {$Alias.GetEnumerator() |Add-CharacterConstant}
    }
}
