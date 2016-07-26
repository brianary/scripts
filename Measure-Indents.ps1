<#
.Synopsis
    Measures the indentation characters used in a text file.

.Parameter Path
    A file to measure.

.Example
    Measure-Indents.ps1 Program.cs


    Tab Space Mix Other
    --- ----- --- -----
      1    17   0     0
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$Path
)
Begin
{
    $Count = New-Object psobject -Property @{Tab=0;Space=0;Mix=0;Other=0}
}
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
        else {Write-Warning "Unexpected indent type: $($IndentChars.GetType().FullName)"}
    }
}
End
{
    $Count
}