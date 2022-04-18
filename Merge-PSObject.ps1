<#
.SYNOPSIS
Create a new PSObject by recursively combining the properties of PSObjects.

.INPUTS
System.Management.Automation.PSObject to combine.

.OUTPUTS
System.Management.Automation.PSObject combining the inputs.

.LINK
Get-Member

.LINK
Add-Member

.EXAMPLE
Merge-PSObject.ps1 ([pscustomobject]@{a=1;b=2}) ([pscustomobject]@{b=0;c=3})

a b c
- - -
1 2 3

.EXAMPLE
Merge-PSObject.ps1 ([pscustomobject]@{a=1;b=2}) ([pscustomobject]@{b=0;c=3}) -Force

a b c
- - -
1 0 3

.EXAMPLE
'{"a":1,"b":{"u":3},"c":{"v":5}}','{"a":{"w":8},"b":2,"c":{"x":6}}' |ConvertFrom-Json |Merge-PSObject.ps1 -Accumulate -Force |select -Last 1 |ConvertTo-Json

| {
|   "a": {
|     "w": 8
|   },
|   "b": 2,
|   "c": {
|     "v": 5,
|     "x": 6
|   }
| }
#>

#Requires -Version 3
[CmdletBinding()][OutputType([PSObject])] Param(
# Initial PSObject to combine.
[Parameter(Position=0)][PSObject] $ReferenceObject = [pscustomobject]@{},
<#
PSObjects to combine. PSObject descendant properties are recursively merged.
Primitive values are overwritten by any matching ones in the new PSObject.
#>
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)][PSObject] $InputObject,
# Continue merging each pipeline object's properties into the same accumulator object.
[switch] $Accumulate,
# Overwrite existing properties.
[switch] $Force
)
Begin {if($Accumulate) {$value = $ReferenceObject.PSObject.Copy()}}
Process
{
	if(!$Accumulate) {$value = $ReferenceObject.PSObject.Copy()}
	foreach($p in $InputObject |Get-Member -Type Properties)
	{
		$name,$type = $p.Name,$p.MemberType
		$newvalue = $InputObject.$name
		if(!($value |Get-Member $name -Type $type))
		{
			$value |Add-Member $name -Type $type -Value $newvalue
		}
		elseif($Force)
		{
			$currentvalue = $value.$name
			$value.$name =
				if($currentvalue -isnot [PSObject] -or $newvalue -isnot [PSObject]) {$newvalue}
				else {Merge-PSObject.ps1 $currentvalue $newvalue}
		}
		elseif($value.$name -is [PSObject] -and $newvalue -is [PSObject])
		{
			$value.$name = Merge-PSObject.ps1 $value.$name $newvalue
		}
	}
	return $value
}
