<#
.SYNOPSIS
Tests whether the given string can be parsed as a date.

.INPUTS
System.String containing a possible date to test parse.

.OUTPUTS
System.Boolean indicating the string is a parseable date.

.FUNCTIONALITY
Date and time

.LINK
https://msdn.microsoft.com/library/8kb3ddd4.aspx

.EXAMPLE
Test-DateTime.ps1 '2017-02-29T11:38:00'

False

.EXAMPLE
Test-DateTime.ps1 '2000-2-29T9:33:00' -Format 'yyyy-M-dTH:mm:ss'

True

.EXAMPLE
Test-Datetime.ps1 970313 -Format 'yyMMdd'

True

.EXAMPLE
Test-DateTime.ps1 '1900-02-29'

False
#>

[CmdletBinding()][OutputType([bool])] Param(
# The string to test for datetime parseability.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$Date,
# Precise, known format(s) to use to try parsing the datetime.
[string[]]$Format
)

[ref]$value = [datetime]::MinValue
if(!$Format) {[datetime]::TryParse($Date,$value)}
else {[datetime]::TryParseExact($Date,$Format,[Globalization.CultureInfo]::InvariantCulture,'None',$value)}
