<#
.SYNOPSIS
Accepts justifications for script analysis rule violations, fixing the rest using Invoke-ScriptAnalysis.

.FUNCTIONALITY
Scripts

.LINK
https://docs.microsoft.com/powershell/module/psscriptanalyzer/invoke-scriptanalyzer

.EXAMPLE
Repair-ScriptStyle.ps1 .\Repair-ScriptStyle.ps1

 PSAvoidUsingWriteHost in A:\Scripts\Repair-ScriptStyle.ps1
 (!) Warning
 Lines: 19, 24, 25, 26, 27, 31, 32
 File 'Repair-ScriptStyle.ps1' uses ModernConveniences\Write-Info. Avoid using ModernConveniences\Write-Info because it might not work in all hosts,
does not work when there is no host, and (prior to PS 5.0) cannot be suppressed, captured, or redirected.
Instead, use Write-Output, Write-Verbose, or Write-Information.

Confirm
Are you sure you want to perform this action?
Performing the operation "provide justification" on target "PSAvoidUsingWriteHost in A:\Scripts\Repair-ScriptStyle.ps1".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
#>

#Requires -Version 3
#Requires -Modules PSScriptAnalyzer
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost','',
Justification='This script is not intended for pipeline redirection. Also, it uses color.')]
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
# The path to a PowerShell script file to repair the style of.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path
)
Process
{
	$suppress = @()
	foreach($rule in Invoke-ScriptAnalyzer $Path |Group-Object RuleName)
	{
		$name = $rule.Name
		ModernConveniences\Write-Info " $name in $Path " -ForegroundColor Magenta -BackgroundColor White
		foreach($severity in $rule.Group |Group-Object Severity)
		{
			switch($severity.Name)
			{
				Information {ModernConveniences\Write-Info ' 🆗 Information ' -ForegroundColor Blue -BackgroundColor White}
				Warning {ModernConveniences\Write-Info ' ⚠️ Warning ' -ForegroundColor Yellow -BackgroundColor DarkGray}
				Error {ModernConveniences\Write-Info ' ❌ Error ' -ForegroundColor Red -BackgroundColor White}
				default {ModernConveniences\Write-Info " $($severity.Name) " -ForegroundColor Cyan -BackgroundColor White}
			}
			foreach($message in $severity.Group |Group-Object Message)
			{
				ModernConveniences\Write-Info " Lines: $($message.Group.Line -join ', ')" -ForegroundColor Cyan -BackgroundColor Black
				ModernConveniences\Write-Info " $($message.Name)"
			}
		}
		if(!$PSCmdlet.ShouldProcess("$name in $Path",'provide justification')) {continue}
		$suppress += @"
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('$name','',
Justification='$((Read-Host 'Justification') -replace "'","''")')]

"@
	}
	if($suppress)
	{
		(Get-Content $Path -Raw) -replace '(?m)^(\[CmdletBinding\b)',"$suppress`$1" |
			ForEach-Object {$_.Trim()} |
			Out-File $Path utf8BOM
	}
	Invoke-ScriptAnalyzer $Path -Fix
}
