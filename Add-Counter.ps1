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
	Get-PSProvider |Add-Counter Position |select Name,Position

	Name        Position
	----        --------
	Registry           1
	Alias              2
	Environment        3
	FileSystem         4
	Function           5
	Variable           6
	Certificate        7
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0)][string] $PropertyName = 'Counter',
[Parameter(Position=1)][int] $InitialValue = 1,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][psobject] $InputObject
)
Begin { $i = $InitialValue }
Process { Add-Member $PropertyName ($i++) -InputObject $InputObject -PassThru }
