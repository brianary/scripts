<#
.Synopsis
	Adds a incrementing integer property to each pipeline object.

.Parameter PropertyName
	The name of the property to add.

.Parameter InitialValue
	The starting number to count from.

.Parameter InputObject
	The object to add the property to.

.Link
	Add-Member

.Example
	Get-PSProvider |Add-Counter Position |select Position,Name

	Position Name
	-------- ----
	       1 Registry
	       2 Alias
	       3 Environment
	       4 FileSystem
	       5 Function
	       6 Variable
	       7 Certificate
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0)][string] $PropertyName = 'Counter',
[Parameter(Position=1)][int] $InitialValue = 1,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][psobject] $InputObject
)
Begin { $i = $InitialValue }
Process { Add-Member $PropertyName ($i++) -InputObject $InputObject -PassThru }
