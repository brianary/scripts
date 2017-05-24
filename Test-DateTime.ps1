<#
.Synopsis
    Tests whether the given string can be parsed as a date.

.Parameter Date
    The string to test for datetime parseability.

.Parameter Format
    Precise, known format(s) to use to try parsing the datetime.

.Link
    https://msdn.microsoft.com/library/8kb3ddd4.aspx

.Example
    Test-DateTime.ps1 '2017-02-29T11:38:00'

    False

.Example
    Test-DateTime.ps1 '2000-2-29T9:33:00' -Format 'yyyy-M-dTH:mm:ss'

    True

.Example
    Test-Datetime.ps1 970313 -Format 'yyMMdd'

    True

.Example
    Test-DateTime.ps1 '1900-02-29'

    False
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$Date,
[string[]]$Format
)

[ref]$value = [datetime]::MinValue
if(!$Format) {[datetime]::TryParse($Date,$value)}
else {[datetime]::TryParseExact($Date,$Format,[Globalization.CultureInfo]::InvariantCulture,'None',$value)}
