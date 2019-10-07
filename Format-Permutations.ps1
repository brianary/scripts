<#
.Synopsis
	Builds format strings using every combination of elements from multiple arrays.

.Parameter Format
    A standard .NET format string as used with the PowerShell -f operator.

.Parameter InputObject
    A list of lists to put together in all combinations (a Cartesian cross-product) and
    format with the supplied format string.

.Outputs
    System.String list of all combinations

.Link
    https://social.technet.microsoft.com/wiki/contents/articles/7855.powershell-using-the-f-format-operator.aspx

.Example
	Format-Permutations.ps1 'srv-{0}-{1:00}' 'dev','test','stage','live' (1..4)

    srv-dev-01
    srv-dev-02
    srv-dev-03
    srv-dev-04
    srv-test-01
    srv-test-02
    srv-test-03
    srv-test-04
    srv-stage-01
    srv-stage-02
    srv-stage-03
    srv-stage-04
    srv-live-01
    srv-live-02
    srv-live-03
    srv-live-04
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string[]])] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Format,
[Parameter(Position=1,Mandatory=$true,ValueFromRemainingArguments=$true)][ValidateNotNull()][object[][]] $InputObject
)

function Format-Permute([string]$Format,[object[][]]$NextValues,[object[]]$Values = @())
{
    if($Values.Length -eq 1) {$NextValues[0] |foreach {$Format -f ($Values+$_)}}
    else {$NextValues[0] |foreach {Format-Permute $Format $NextValues[1..$NextValues.Length] ($Values+$_)}}
}

Format-Permute $Format $InputObject
