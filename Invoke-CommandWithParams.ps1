<#
.Synopsis
    Execute a command by using matching dictionary entries as parameters.

.Parameter Name
    The name of a command to run using the parameter dictionary.

.Parameter Dictionary
    A dictionary of parameters to supply to the command.

.Parameter ExcludeKeys
    A list of dictionary keys to omit when sending dictionary parameters to the command.

.Parameter OnlyMatches
    Compares the keys in the parameter dictionary with the parameters supported by the command,
    omitting any dictionary entries that do not map to known command parameters.
    No checking for valid parameter sets is performed.

.Inputs
    System.Collections.IDictionary, the parameters to supply to the command.

.Link
    Select-DictionaryKeys.ps1

.Link
    Format-PSLiterals.ps1

.Link
    Get-Command

.Example
    @{Object="Hello, world!"} |Invoke-CommandWithParams.ps1 Write-Host

    Hello, world!

.Example
    $PSBoundParameters |Invoke-CommandWithParams.ps1 Send-MailMessage -OnlyMatches

    Uses any of the calling script's parameters matching those found in the Send-MailMessage param list to call the command.
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('CommandName')][string]$Name,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][Alias('Hashset')][Collections.IDictionary]$Dictionary,
[Alias('Except')][string[]]$ExcludeKeys,
[Alias('Matching','')][switch]$OnlyMatches
)
Begin
{
    if($OnlyMatches)
    {
        [string[]]$exceptParams = [string[]][System.Management.Automation.PSCmdlet]::CommonParameters +
            [string[]][System.Management.Automation.PSCmdlet]::OptionalCommonParameters
        Write-Verbose "Common parameters ($($exceptParams.Length)): $exceptParams"
        if($ExcludeKeys) {$exceptParams += $ExcludeKeys}
        Write-Verbose "Excluding parameters ($($exceptParams.Length)): $exceptParams"
        [string[]]$params = (Get-Command $Name).Parameters.Keys |? {$_ -notin $exceptParams}
        Write-Verbose "Parameters ($($params.Length)): $params"
    }
}
Process
{
    $selectedParams = 
        if($OnlyMatches) {$Dictionary |Select-DictionaryKeys.ps1 -Keys $params -SkipNullValues}
        else {$Dictionary}
    Write-Verbose "$Name $($selectedParams.Keys |% {"-$_ $(Format-PSLiterals.ps1 $selectedParams.$_ -IndentBy '')"})"
    &$Name @selectedParams
}
