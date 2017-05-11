<#
.Synopsis
    Creates local variables from a data row or dictionary (hashtable).

.Parameter Dictionary
    A hash of string names to any values to set as variables.

.Parameter InputObject
    An object with properties to set as variables.
    Works with DataRows.

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

#requires -version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='Dictionary',Position=0,Mandatory=$true,ValueFromPipeline=$true)][Collections.IDictionary]$Dictionary,
[Parameter(ParameterSetName='InputObject',Position=0,Mandatory=$true,ValueFromPipeline=$true)][PSObject]$InputObject
)
Process
{
    switch($PSCmdlet.ParameterSetName)
    {
        Dictionary
        {
            [string[]]$vars = $Dictionary.Keys |? {$_ -is [string]}
            Write-Verbose "Importing $($vars.Count) Dictionary entries"
            Write-Verbose "Importing: $vars"
            foreach($var in $vars) {Set-Variable $var $Dictionary.$var -Scope 1}
        }

        InputObject
        {
            [string[]]$vars = Get-Member -InputObject $InputObject -MemberType Properties |% Name
            Write-Verbose "Importing $($vars.Count) InputObject properties"
            Write-Verbose "Importing $vars"
            foreach($var in $vars) {Set-Variable $var $InputObject.$var -Scope 1}
        }
    }
}