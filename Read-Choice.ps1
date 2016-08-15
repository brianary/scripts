<#
.Synopsis
    Returns choice selected from a list of options.

.Parameter Choices
    A list of choice strings. Use & in front of a letter to make it a hotkey.

.Parameter ChoiceHash
    An ordered hash of choices mapped to help text descriptions.
    Use & in front of a letter to make it a hotkey.

.Parameter Caption
    A title to use for the prompt.

.Parameter Message
    Instructional text to provide in the prompt.

.Parameter DefaultIndex
    The index of the default choice.
    Use -1 to for no default.
    Otherwise, the first item (index 0) is the default.

.Link
    https://msdn.microsoft.com/library/system.management.automation.host.pshostuserinterface.promptforchoice.aspx

.Example
    Read-Choice.ps1 one,two,three


    Please select:
    [] one  [] two  [] three  [?] Help (default is "one"):
    one

.Example
    Read-Choice.ps1 ([ordered]@{'&one'='first thing';'&two'='second thing';'t&hree'='third thing'}) -Message 'Pick:'


    Pick:
    [O] one  [T] two  [H] three  [?] Help (default is "O"): ?
    O - first thing
    T - second thing
    H - third thing
    [O] one  [T] two  [H] three  [?] Help (default is "O"):
    &one
#>

#requires -Version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='ChoicesArray',Position=0,Mandatory=$true)][string[]]$Choices,
[Parameter(ParameterSetName='ChoicesHash',Position=0,Mandatory=$true)]
[Collections.Specialized.OrderedDictionary]$ChoiceHash,
[string]$Caption,
[string]$Message = 'Please select:',
[int]$DefaultIndex
)
$choicelist =
    if($Choices) {$Choices |% {New-Object System.Management.Automation.Host.ChoiceDescription $_}}
    else
    {
        $Choices = @($ChoiceHash.Keys)
        $Choices |% {New-Object System.Management.Automation.Host.ChoiceDescription $_,$ChoiceHash.$_}
    }
$Choices[$Host.UI.PromptForChoice($Caption,$Message,$choicelist,$DefaultIndex)]
