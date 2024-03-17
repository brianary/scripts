<#
.SYNOPSIS
Exports table data as a T-SQL MERGE statement.

.OUTPUTS
System.String of SQL MERGE script to replicate the table's data.

.FUNCTIONALITY
Database

.LINK
https://learn.microsoft.com/sql/t-sql/statements/merge-transact-sql

.LINK
https://dbatools.io/

.EXAMPLE
Get-DbaDbTable -SqlInstance $server -Schema HumanResources -Table Department |Export-TableMerge.ps1

if exists (select * from information_schema.columns where table_schema = 'HumanResources' and table_name = 'Department'
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert [HumanResources].[Department] on;

merge [HumanResources].[Department] as target
using ( values
(1, 'Engineering', 'Research and Development', '2008-04-30 00:00:00.00000'),
(2, 'Tool Design', 'Research and Development', '2008-04-30 00:00:00.00000'),
(3, 'Sales', 'Sales and Marketing', '2008-04-30 00:00:00.00000'),
(4, 'Marketing', 'Sales and Marketing', '2008-04-30 00:00:00.00000'),
(5, 'Purchasing', 'Inventory Management', '2008-04-30 00:00:00.00000'),
(6, 'Research and Development', 'Research and Development', '2008-04-30 00:00:00.00000'),
(7, 'Production', 'Manufacturing', '2008-04-30 00:00:00.00000'),
(8, 'Production Control', 'Manufacturing', '2008-04-30 00:00:00.00000'),
(9, 'Human Resources', 'Executive General and Administration', '2008-04-30 00:00:00.00000'),
(10, 'Finance', 'Executive General and Administration', '2008-04-30 00:00:00.00000'),
(11, 'Information Services', 'Executive General and Administration', '2008-04-30 00:00:00.00000'),
(12, 'Document Control', 'Quality Assurance', '2008-04-30 00:00:00.00000'),
(13, 'Quality Assurance', 'Quality Assurance', '2008-04-30 00:00:00.00000'),
(14, 'Facilities and Maintenance', 'Executive General and Administration', '2008-04-30 00:00:00.00000'),
(15, 'Shipping and Receiving', 'Inventory Management', '2008-04-30 00:00:00.00000'),
(16, 'Executive', 'Executive General and Administration', '2008-04-30 00:00:00.00000')
) as source ([DepartmentID], [Name], [GroupName], [ModifiedDate])
on source.[DepartmentID] = target.[DepartmentID]
when matched then
update set [Name] = source.[Name],
[GroupName] = source.[GroupName],
[ModifiedDate] = source.[ModifiedDate]
when not matched by target then
insert ([DepartmentID], [Name], [GroupName], [ModifiedDate])
values (source.[DepartmentID], source.[Name], source.[GroupName], source.[ModifiedDate])
when not matched by source then delete ;

if exists (select * from information_schema.columns where table_schema = 'HumanResources' and table_name = 'Department'
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert [HumanResources].[Department] off;
#>

#Requires -Version 7
#Requires -Modules dbatools
using namespace Microsoft.SqlServer.Management.Smo
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Table] $Table
)
Begin
{
    filter ConvertTo-SqlName([Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Name)
    {
        return [SqlSmoObject]::QuoteString($Name,'[',']')
    }

    filter ConvertTo-SqlLiteral([Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)] $Value)
    {
        switch($Value.GetType())
        {
            dbnull   {'null'}
            string   {"'$($Value -replace "'","''")'"}
            datetime {Get-Date $Value -f "\'yyyy-MM-dd HH:mm:ss.fffff\'"}
            bool     {$Value ? 1 : 0}
            guid     {"'$Value'"}
            default  {$Value}
        }
    }

    function Format-Merge([Table] $Table)
    {
        Import-CharConstants.ps1 NL
        $identitytest = @"
if exists (select * from information_schema.columns where table_schema = $(ConvertTo-SqlLiteral $Table.Schema) and table_name = $(ConvertTo-SqlLiteral $Table.Name)
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
"@
        $columns = ($Table.Columns.Name |ConvertTo-SqlName) -join ', '
        $fieldupdates = ($Table.Columns |Where-Object {!$_.InPrimaryKey} |Select-Object -ExpandProperty Name |
            ConvertTo-SqlName |ForEach-Object {"$_ = source.$_"}) -join ",$NL"
        $fieldupdates =
            if($fieldupdates) {"when matched then${NL}update set $fieldupdates"}
            else {"-- skip 'matched' condition (no non-key columns to update)"}
        return @"
$identitytest
set identity_insert $Table on;

merge $Table as target
using ( values
$((Invoke-DbaQuery -SqlInstance $Table.Parent.Parent -Database $Table.Parent.Name -Query "select * from $Table;" -As DataRow |
    ForEach-Object {"($(($_.ItemArray |ConvertTo-SqlLiteral) -join ', '))"}) -join ",$NL")
) as source ($columns)
on $(($Table.Columns |Where-Object {$_.InPrimaryKey} |Select-Object -ExpandProperty Name |ConvertTo-SqlName |
    ForEach-Object {"source.$_ = target.$_"}) -join "${NL}and ")
$fieldupdates
when not matched by target then
insert ($columns)
values ($(($Table.Columns.Name |ConvertTo-SqlName |ForEach-Object {"source.$_"}) -join ', '))
when not matched by source then delete ;

$identitytest
set identity_insert $Table off;
"@
    }
}
Process
{
    return Format-Merge $Table
}
