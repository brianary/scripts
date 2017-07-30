<#
.Synopsis
    Formats a datetime as a LogParser literal.

.Parameter Value
    The DateTime value to convert to a LogParser literal.

.Inputs
    System.DateTime to encode for use as a literal in a LogParser query.

.Outputs
    System.String to use as a timestamp literal in a LogParser query.

.Link
    https://www.microsoft.com/en-us/download/details.aspx?id=24659

.Example
    logparser "select * from ex17*.log where to_localtime(timestamp(date,time)) < $(Get-Date|ConvertTo-LogParserTimestamp.ps1)"
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][datetime]$Value
)
"timestamp('$(Get-Date $Value -Format 'yyyy-MM-dd HH:mm:ss')','yyyy-MM-dd HH:mm:ss')"
