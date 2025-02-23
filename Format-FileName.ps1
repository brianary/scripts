<#
.SYNOPSIS
Returns a valid and safe filename from a given string.

.INPUTS
System.String containing a filename that may contain invalid characters.

.OUTPUTS
System.String containing a filename without any invalid characters.

.FUNCTIONALITY
Unicode

.EXAMPLE
'app*.log' |Format-FileName.ps1

app_.log

.EXAMPLE
'one|two-<three>' |Format-FileName.ps1 -CurrentPlatformOnly

one_two-_three_

.EXAMPLE
'app-${value}.config' |Format-FileName.ps1 Ascii -ExcludeChars '$','{','}'

app-_value_.config
#>

using namespace System.Text
#Requires -Version 7
[CmdletBinding()][OutputType([string])] Param(
# Allows limiting the filename to either ASCII or Basic Multilingual Plane characters, if specified.
[ValidateSet('Bmp', 'Ascii')][string] $OutputBlock,
# The character to use to replace a range of invalid characters.
[rune] $Replacement = '_'[0],
# Characters to include (overrides exclusions).
[ValidateNotNull()][char[]] $IncludeChars = @(),
# Characters to exclude.
[ValidateNotNull()][char[]] $ExcludeChars = @(),
# Runes to include (overrides excludes).
[ValidateNotNull()][rune[]] $IncludeRunes = @(),
# Runes to exclude.
[ValidateNotNull()][rune[]] $ExcludeRunes = @(),
# Indicates that only characters invalid for the current platform should be excluded by default.
[switch] $CurrentPlatformOnly,
# The string value to sanitize for use as a filename.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $InputObject
)
Begin
{
    [char[]] $skipchars = $CurrentPlatformOnly ? ([IO.Path]::GetInvalidFileNameChars()) :
        @('"', '*', '/', ':', '<', '>', '?', '\', '|')
    function Copy-Rune
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][rune] $Rune
        )
        Set-Variable skipping $false -Scope 1
        (Get-Variable value -Scope 1).Value.Append($Rune) |Out-Null
    }
    function Skip-Rune
    {
        $skipping = Get-Variable skipping -Scope 1
        if(!$skipping.Value)
        {
            $skipping.Value = $true
            (Get-Variable value -Scope 1).Value.Append($Replacement) |Out-Null
        }
    }
}
Process
{
    $skipping, $value = $false, (New-Object StringBuilder)
    foreach ($rune in $InputObject.EnumerateRunes())
    {
        if($rune -in $IncludeRunes) {Copy-Rune $rune}
        elseif($rune -in $ExcludeRunes) {Skip-Rune}
        elseif($rune.IsBmp)
        {
            [char] $char = $rune.Value
            if($char -in $IncludeChars) {Copy-Rune $rune}
            elseif($char -in $ExcludeChars) {Skip-Rune}
            elseif($char -in $skipchars -or [char]::IsControl($char)) {Skip-Rune}
            elseif($OutputBlock -eq 'Ascii' -and !$rune.IsAscii) {Skip-Rune}
            else {Copy-Rune $rune}
        }
        elseif($OutputBlock -eq 'Bmp') {Skip-Rune}
        else {Copy-Rune $rune}
    }
    return $value.ToString()
}
