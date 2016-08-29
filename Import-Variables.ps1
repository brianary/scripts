<#
.Synopsis
    Creates local variables from records or hashtables.

.Parameter DataRow
    DataRows may be piped into this script from the SQLPS Import-Sqlcmd cmdlet to create variables from record fields.

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
        $Hashtable.Keys |
            ? {$_ -is [string]} |
            % {Set-Variable $_ $Hashtable.$_ -Scope 1}
    }
    elseif($DataRow)
    {
        $row=$_
        Get-Member -InputObject $DataRow -MemberType Properties |
            % {Set-Variable $_.Name $row[$_.Name] -Scope 1}
    }
}