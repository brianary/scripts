<#
.Synopsis
    Creates local variables from a data row or hashtable.

.Parameter DataRow
    DataRows may be piped into this script from the Import-Sqlcmd cmdlet to create variables from record fields.

.Parameter Hashtable
    A hash of string names to any values to create as variables.

.Example
    if($line -match '\AProject\("(?<TypeGuid>[^"]+)"\)') {Import-Variables.ps1 $Matches}


    Copies $Matches.TypeGuid to $TypeGuid if a match is found.

.Example
    Invoke-Sqlcmd "select ProductID, Name, ListPrice from Production.Product where ProductID = 1;" -Server 'Server\instance' -Database AdventureWorks |Import-Variables.ps1


    Copies field values into $ProductID, $Name, and $ListPrice.
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='DataRow',Position=0,Mandatory=$true,ValueFromPipeline=$true)][Data.DataRow]$DataRow,
[Parameter(ParameterSetName='Hashtable',Position=0,Mandatory=$true,ValueFromPipeline=$true)][hashtable]$Hashtable
)
Process
{
    if($Hashtable)
    {
        Write-Verbose "Importing $($Hashtable.Count) Hashtable entries"
        $vars = $Hashtable.Keys |? {$_ -is [string]}
        Write-Verbose "Importing: $vars"
        foreach($var in $vars) {Set-Variable $var $Hashtable.$var -Scope 1}
    }
    elseif($DataRow)
    {
        Write-Verbose "Importing $($DataRow.Table.Columns.Count) DataRow columns"
        $vars = Get-Member -InputObject $DataRow -MemberType Properties |% Name
        Write-Verbose "Importing: $vars"
        foreach($var in $vars) {Set-Variable $var $DataRow[$var] -Scope 1}
    }
}