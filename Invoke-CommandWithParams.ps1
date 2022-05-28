<#
.SYNOPSIS
Execute a command by using matching dictionary entries as parameters.

.INPUTS
System.Collections.IDictionary, the parameters to supply to the command.

.LINK
Split-Keys.ps1

.LINK
ConvertTo-PowerShell.ps1

.LINK
Get-Command

.EXAMPLE
@{Object="Hello, world!"} |Invoke-CommandWithParams.ps1 Write-Host

Hello, world!

.EXAMPLE
@{TypeName='string';ArgumentList='test';PipelineVariable='Global:x'} |Invoke-CommandWithParams.ps1 New-Object -ParameterSet Net -OnlyMatches -IncludeCommon |ForEach-Object {"x = $x"}

x = test

(The 'Global:' is necessary due to some scope issues.)

.EXAMPLE
$PSBoundParameters |Invoke-CommandWithParams.ps1 Send-MailMessage -OnlyMatches

Uses any of the calling script's parameters matching those found in the Send-MailMessage param list to call the command.
#>

[CmdletBinding()] Param(
# The name of a command to run using the parameter dictionary.
[Parameter(Position=0,Mandatory=$true)][Alias('CommandName')][string] $Name,
# The name of a parameter set defined by the cmdlet, to constrain to those parameters.
[string] $ParameterSet,
# A dictionary of parameters to supply to the command.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][Alias('Hashset')][Collections.IDictionary] $Dictionary,
# A list of dictionary keys to omit when sending dictionary parameters to the command.
[Alias('Except')][string[]] $ExcludeKeys = @(),
<#
Compares the keys in the parameter dictionary with the parameters supported by the command,
omitting any dictionary entries that do not map to known command parameters.
#>
[Alias('Matching','')][switch] $OnlyMatches,
# Includes common parameters such as -Verbose and -WhatIf.
[switch] $IncludeCommon
)
Begin
{
	if($OnlyMatches)
	{
		$paramsSpec = @{ CommandName = $Name; IncludeCommon = $IncludeCommon }
		if($ParameterSet) {$paramsSpec['ParameterSet'] = $ParameterSet}
		[string[]] $params = Get-CommandParameters.ps1 @paramsSpec -NamesOnly |Where-Object {$_ -notin $ExcludeKeys}
	}
}
Process
{
	$selectedParams =
		if($OnlyMatches) {$Dictionary |Split-Keys.ps1 -Keys $params -SkipNullValues}
		else {$Dictionary}
	Write-Debug "$Name $($selectedParams.Keys |
		ForEach-Object {"-$_ $(ConvertTo-PowerShell.ps1 $selectedParams.$_ -IndentBy '')"})"
	return &$Name @selectedParams
}
