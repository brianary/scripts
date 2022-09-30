<#
.SYNOPSIS
Generates a Mermaid entity relation diagram for database tables.
#>

#Requires -Version 3
[CmdledBinding()] Param(
# An SMO table object associated to the database to examine.
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)]
[Microsoft.SqlServer.Management.Smo.Table] $Table
)
Begin
{
	filter Format-ColumnAsMermaid
	{
		Param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[Microsoft.SqlServer.Management.Smo.DataType] $DataType,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][bool] $InPrimaryKey,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][bool] $IsForeignKey,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][bool] $Nullable,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][bool] $Identity,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][long] $IdentitySeed,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][long] $IdentityIncrement,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Default
		)
		$key = if($InPrimaryKey){' PK'}elseif($IsForeignKey){' FK'}
		[string[]] $details = @()
		if($Identity) {$details += "identity($IdentitySeed,$IdentityIncrement)"}
		if($details) {$details = ' "' + ($details -join ' ,') + '"'}
		return "$DataType $Name$key$details"
	}
	filter Format-TableAsMermaid
	{
		Param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[Microsoft.SqlServer.Management.Smo.ColumnCollection] $Columns
		)
		$Local:OFS = "$([Environment]::NewLine)`t"
		return @"
$Name {
	$($Columns |Format-ColumnAsMermaid)
}
"@
	}
}
Process
{
	$Table |Format-TableAsMermaid
}
