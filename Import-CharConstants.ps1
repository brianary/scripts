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
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)][string[]] $CharacterName,
# The scope of the constant.
[string] $Scope = 'Local',
<#
Appends a U+FE0F VARIATION SELECTOR-16 suffix to the character, which suggests an emoji presentation
for characters that support both a simple text presentation as well as a color emoji-style one.
#>
[switch] $AsEmoji
)
Begin {$level = Add-ScopeLevel.ps1 -Scope $Scope}
Process
{
    foreach($name in $CharacterName)
    {
        $cname = $name -replace ':'
        $value = $name -ceq 'NL' ? [Environment]::NewLine : (Get-UnicodeByName.ps1 -Name $name -AsEmoji:$AsEmoji)
        Set-Variable -Name $cname -Value $value -Scope $level -Option Constant -Description $name
    }
}
