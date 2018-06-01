<#
.Synopsis
    Returns the possible values of the specified enumeration.

.Parameter Type
    The enumeration type name.

.Inputs
    System.Type of an Enum to get the values for.

.Outputs
    System.Management.Automation.PSObject with the Value and Name for each defined
    value of the Enum.

.Example
    Get-EnumValues Management.Automation.ActionPreference

    Value Name
    ----- ----
        0 SilentlyContinue
        1 Stop
        2 Continue
        3 Inquire
        4 Ignore
        5 Suspend

.Example
    Get-EnumValues ConsoleColor

    Value Name
    ----- ----
        0 Black
        1 DarkBlue
        2 DarkGreen
        3 DarkCyan
        4 DarkRed
        5 DarkMagenta
        6 DarkYellow
        7 Gray
        8 DarkGray
        9 Blue
       10 Green
       11 Cyan
       12 Red
       13 Magenta
       14 Yellow
       15 White

.Example
    Get-EnumValues.ps1 System.Web.Security.AntiXss.MidCodeCharts


    ·   Value Name
        ----- ----
            0 None
            1 GreekExtended
            2 GeneralPunctuation
            4 SuperscriptsAndSubscripts
            8 CurrencySymbols
           16 CombiningDiacriticalMarksForSymbols
           32 LetterlikeSymbols
           64 NumberForms
          128 Arrows
          256 MathematicalOperators
          512 MiscellaneousTechnical
         1024 ControlPictures
         2048 OpticalCharacterRecognition
         4096 EnclosedAlphanumerics
         8192 BoxDrawing
        16384 EthiopicExtended
        16384 EthiopicExtended
        32768 GeometricShapes
        65536 MiscellaneousSymbols
       131072 Dingbats
       262144 MiscellaneousMathematicalSymbolsA
       524288 SupplementalArrowsA
      1048576 BraillePatterns
      2097152 SupplementalArrowsB
      4194304 MiscellaneousMathematicalSymbolsB
      8388608 SupplementalMathematicalOperators
     16777216 MiscellaneousSymbolsAndArrows
     33554432 Glagolitic
     67108864 LatinExtendedC
    134217728 Coptic
    268435456 GeorgianSupplement
    536870912 Tifinagh
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject[]])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Type]$Type
)
Process
{
    [enum]::GetValues($Type) |
        % {New-Object PSObject -Property ([ordered]@{Value=[int]$_;Name=[string]$_})}
}
