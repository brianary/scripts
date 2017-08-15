<#
.Synopsis
    Creates local variables from a data row or dictionary (hashtable).

.Parameter InputObject
    A hash of string names to any values to set as variables,
    or a DataRow or object with properties to set as variables.
    Works with DataRows.

.Inputs
    System.Management.Automation.PSCustomObject with properties to import as variables.

.Example
    if($line -match '\AProject\("(?<TypeGuid>[^"]+)"\)') {Import-Variables.ps1 $Matches}

    Copies $Matches.TypeGuid to $TypeGuid if a match is found.

.Example
    Invoke-Sqlcmd "select ProductID, Name, ListPrice from Production.Product where ProductID = 1;" -Server 'Server\instance' -Database AdventureWorks |Import-Variables.ps1

    Copies field values into $ProductID, $Name, and $ListPrice.

.Example
    if($env:ComSpec -match '^(?<ComPath>.*?\\)(?<ComExe>[^\\]+$)'){Import-Variables.ps1 $Matches -Verbose}

    Sets $ComPath and $ComExe from the regex captures if the regex matches.

.Example
    Invoke-RestMethod https://api.github.com/ |Import-Variables.ps1 ; Invoke-RestMethod $emojis_url
    
    Sets variables from the fields returned by the web service: $current_user_url, $emojis_url, &c.
    Then fetches the list of GitHub emojis.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][PSObject]$InputObject
)
Process
{
    $isDict = $InputObject -is [Collections.IDictionary]
    [string[]]$vars = 
        if($isDict) {$InputObject.Keys |? {$_ -is [string]}}
        else {Get-Member -InputObject $InputObject -MemberType Properties |% Name}
    if(!$vars){return}
    Write-Verbose "Importing $($vars.Count) $(if($isDict){'keys'}else{'properties'}): $vars"
    foreach($var in $vars) {Set-Variable $var $InputObject.$var -Scope 1}
}
