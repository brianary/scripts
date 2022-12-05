<#
.SYNOPSIS
Formats a datetime as a LogParser literal.

.INPUTS
System.DateTime to encode for use as a literal in a LogParser query.

.OUTPUTS
System.String to use as a timestamp literal in a LogParser query.

.FUNCTIONALITY
Date and time

.LINK
https://www.microsoft.com/en-us/download/details.aspx?id=24659

.EXAMPLE
logparser "select * from ex17*.log where to_localtime(timestamp(date,time)) < $(Get-Date|ConvertTo-LogParserTimestamp.ps1)"
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# The DateTime value to convert to a LogParser literal.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][datetime]$Value
)
"timestamp('$(Get-Date $Value -Format 'yyyy-MM-dd HH:mm:ss')','yyyy-MM-dd HH:mm:ss')"
