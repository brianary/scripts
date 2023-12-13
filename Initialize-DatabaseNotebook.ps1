<#
.SYNOPSIS
Populates a new notebook with details about a database.

.FUNCTIONALITY
Database

.EXAMPLE
Initialize-DatabaseNotebook.ps1 -ServerInstance ServerName -DatabaseName AdventureWorks

Adds cells to the current Polyglot Notebook that generates a header, ER diagram, and table stats.
#>

#Requires -Version 7
#Requires -Modules dbatools
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][ValidatePattern('\A[^'']+\z')][string] $ServerInstance,
[Parameter(Position=1,Mandatory=$true)][ValidatePattern('\A[^'']+\z')][string] $DatabaseName,
[switch] $DisableEncryption,
[switch] $AllowWrites
)

Import-CharConstants.ps1 NL -Scope Script

function Add-MainHeader
{
    @"
$DatabaseName database
======================

"@ |Add-NotebookCell.ps1
}

function Add-SqlSupport
{
    '#r "nuget: Microsoft.DotNet.Interactive.SqlServer, *-*"' |Add-NotebookCell.ps1 -Language csharp
}

function Add-ErDiagramGenerator
{
	@"
# generate erDiagram
Get-DbaDatabase -SqlInstance '$ServerInstance' -Database '$DatabaseName' |
    Get-DbaDbTable |
    Where-Object Name -NotIn dtproperties,__MigrationLog,__SchemaSnapshot |
    Export-MermaidER.ps1 |
    Add-NotebookCell.ps1 -Language
"Last updated `$(Get-Date)"
"@ |Add-NotebookCell.ps1 -Language pwsh
}

function Format-TableQuery([Parameter(Mandatory=$true,ValueFromPipeline=$true)][Microsoft.SqlServer.Management.Smo.Table] $Table)
{
	Begin {$i = 0}
	Process
	{
		$datecols = $Table.Columns |Where-Object {$_.DataType.Name -like '*date*'} |Select-Object -ExpandProperty Name
		if($i++ -eq 0)
		{
			if(!$datecols)
			{@"
select '$($Table.Schema -eq 'dbo' ? '' : $Table.Schema + '.')$($Table.Name)' [Table], count(*) [# Records], null [Oldest record], null [Newest record]
  from [$($Table.Schema)].[$($Table.Name)]
"@}
			$datecols |ForEach-Object {@"
select '$($Table.Schema -eq 'dbo' ? '' : $Table.Schema + '.')$($Table.Name)' [Table], count(*) [# Records],
       convert(varchar,min([$_]),111) [Oldest record], convert(varchar,max([$_]),111) [Newest record]
  from [$($Table.Schema)].[$($Table.Name)]
"@}
		}
		else
		{
			if(!$datecols)
			{@"
 union all
select '$($Table.Schema -eq 'dbo' ? '' : $Table.Schema + '.')$($Table.Name)', count(*), null, null
  from [$($Table.Schema)].[$($Table.Name)]
"@}
			$datecols |ForEach-Object {@"
 union all
select '$($Table.Schema -eq 'dbo' ? '' : $Table.Schema + '.')$($Table.Name)', count(*),
       convert(varchar,min([$_]),111), convert(varchar,max([$_]),111)
  from [$($Table.Schema)].[$($Table.Name)]
"@}
		}
	}
}

function Add-TableDetails
{
	@"
#!connect mssql --kernel-name $($DatabaseName -replace '\W+') "Server=$ServerInstance; Initial Catalog=$DatabaseName; Encrypt=$($DisableEncryption ? 'False' : 'True'); ApplicationIntent=$($AllowWrites ? 'ReadWrite' : 'ReadOnly'); Integrated Security=True"
"@ |Add-NotebookCell.ps1 -Language csharp
	$Local:OFS = [Environment]::NewLine
	@"
#!sql-$($DatabaseName -replace '\W+')
-- be sure to remove duplicates as needed
$(Get-DbaDatabase -SqlInstance $ServerInstance -Database $DatabaseName |Get-DbaDbTable |Where-Object Name -NotIn dtproperties,__MigrationLog,__SchemaSnapshot |Format-TableQuery);
"@ |Add-NotebookCell.ps1 -Language sql
}

function Add-DatabaseDetails
{
    Add-MainHeader
    Add-SqlSupport
	Add-ErDiagramGenerator
	Add-TableDetails
}

Add-DatabaseDetails
