<#
.SYNOPSIS
Returns choice selected from a list of options.

.INPUTS
System.String containing a choice to offer.

.OUTPUTS
System.String containing the choice that was selected.

.FUNCTIONALITY
PowerShell

.LINK
https://msdn.microsoft.com/library/system.management.automation.host.pshostuserinterface.promptforchoice.aspx

.EXAMPLE
Read-Choice.ps1 one,two,three

Please select:
[] one  [] two  [] three  [?] Help (default is "one"):
one

.EXAMPLE
Read-Choice.ps1 ([ordered]@{'&one'='first thing';'&two'='second thing';'t&hree'='third thing'}) -Message 'Pick:'

Pick:
[O] one  [T] two  [H] three  [?] Help (default is "O"): ?
O - first thing
T - second thing
H - third thing
[O] one  [T] two  [H] three  [?] Help (default is "O"):
&one
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# A list of choice strings. Use & in front of a letter to make it a hotkey.
[Parameter(ParameterSetName='ChoicesArray',Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[Alias('Options')][string[]] $Choices,
<#
An ordered hash of choices mapped to help text descriptions.
Use & in front of a letter to make it a hotkey.
#>
[Parameter(ParameterSetName='ChoicesHash',Position=0,Mandatory=$true)]
[Alias('Menu')][Collections.IDictionary] $ChoiceHash,
# A title to use for the prompt.
[string] $Caption,
# Instructional text to provide in the prompt.
[string] $Message = 'Please select:',
<#
The index of the default choice.
Use -1 to for no default.
Otherwise, the first item (index 0) is the default.
#>
[int] $DefaultIndex
)
Process
{
	[Management.Automation.Host.ChoiceDescription[]] $choicelist =
		switch($PSCmdlet.ParameterSetName)
		{
			ChoicesArray
			{
				$Choices = $Choices.ForEach({$_}) # flatten nested arrays
				$Choices |ForEach-Object {New-Object System.Management.Automation.Host.ChoiceDescription $_}
			}
			ChoicesHash
			{
				$Choices = @($ChoiceHash.Keys)
				$Choices |ForEach-Object {New-Object System.Management.Automation.Host.ChoiceDescription $_,$ChoiceHash[$_]}
			}
		}
	$Choices[$Host.UI.PromptForChoice($Caption,$Message,$choicelist,$DefaultIndex)]
}

