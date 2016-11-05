<#
.Synopsis
    Creates local variables from a data row or dictionary (hashtable).

.Parameter DataRow
    DataRows may be piped into this script from the Import-Sqlcmd cmdlet to create variables from record fields.

.Parameter Dictionary
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
[Parameter(ParameterSetName='Dictionary',Position=0,Mandatory=$true,ValueFromPipeline=$true)][Collections.IDictionary]$Dictionary
)
Process
{
    switch($PSCmdlet.ParameterSetName)
    {
        DataRow
        {
            Write-Verbose "Importing $($DataRow.Table.Columns.Count) DataRow columns"
            $vars = Get-Member -InputObject $DataRow -MemberType Properties |% Name
            Write-Verbose "Importing: $vars"
            foreach($var in $vars) {Set-Variable $var $DataRow[$var] -Scope 1}
        }

        Dictionary
        {
            Write-Verbose "Importing $($Dictionary.Count) Dictionary entries"
            $vars = $Dictionary.Keys |? {$_ -is [string]}
            Write-Verbose "Importing: $vars"
            foreach($var in $vars) {Set-Variable $var $Dictionary.$var -Scope 1}
        }
    }
}