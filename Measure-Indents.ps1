<#
.Synopsis
    Measures the indentation characters used in a text file.

.Parameter Path
    A file to measure.

.Inputs
    System.String file path to examine.

.Outputs
    System.Management.Automation.PSObject[] with properties indictating indentation counts.

    * Tab: Lines starting with tabs.
    * Space: Lines starting with spaces.
    * Mix: Lines starting with both tabs and spaces.
    * Other: Lines starting with any other whitespace characters than tab or space.

.Example
    Measure-Indents.ps1 Program.cs

    Tab Space Mix Other
    --- ----- --- -----
      1    17   0     0
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$Path
)
Begin { $Count = New-Object psobject -Property @{Tab=0;Space=0;Mix=0;Other=0} }
Process
{
    foreach($line in (Get-Content $Path))
    {
        if($line -notmatch '^(?<Indent>\s+)') {continue}
        $IndentChars = $Matches.Indent.ToCharArray() |select -Unique
        if($IndentChars -is [object[]]) {$Count.Mix++}
        elseif($IndentChars -is [char])
        {
            switch($IndentChars)
            {
                "`t"    {$Count.Tab++}
                ' '     {$Count.Space++}
                default {$Count.Other++}
            }
        }
        else { Write-Warning "Unexpected indent type: $($IndentChars.GetType().FullName)" }
    }
}
End { $Count }
