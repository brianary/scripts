<#
.SYNOPSIS
Writes to the information stream, with color support and more.

.FUNCTIONALITY
PowerShell
#>

#Requires -Version 5.1
[CmdletBinding()] Param(
# Message to write to the information stream.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)] $Message,
# Specifies the text color. There is no default.
[Alias('fg')][Nullable[ConsoleColor]] $ForegroundColor,
# Specifies the background color. There is no default.
[Alias('bg')][Nullable[ConsoleColor]] $BackgroundColor,
<#
The string representations of the input objects are concatenated to form the output.
No spaces or newlines are inserted between the output strings.
No newline is added after the last output string.
#>
[switch] $NoNewLine,
<#
By default, uses -InformationAction Continue.
This uses the standard $InformationPreference instead.
#>
[switch] $UseInformationPreference
)
Process
{
	if(!$UseInformationPreference) {$Local:InformationPreference = 'Continue'}
	Write-Information ([Management.Automation.HostInformationMessage]@{
		Message         = $Message
		ForegroundColor = $ForegroundColor
		BackgroundColor = $BackgroundColor
		NoNewLine       = $NoNewLine
	})
}
