<#
.Synopsis
	Combines dictionaries together into a single dictionary.

.Parameter ReferenceObject
	Initial dictionary value to combine.

.Parameter InputObject
	Hashtables or other dictionaries to combine.

.Parameter Accumulate
	Indicates that the ReferenceObject should be updated with each input dictionary,
	rather than the default behavior of combining the original ReferenceObject with each.

.Parameter Force
	For matching keys, overwrites old values with new ones.
	By default, only new keys are added.

.Inputs
	System.Collections.IDictionary to combine.

.Outputs
	System.Collections.IDictionary combining the inputs.

.Example
	Merge-Dictionary.ps1 @{a=1;b=2} @{b=0;c=3}

	Name                           Value
	----                           -----
	b                              2
	c                              3
	a                              1

.Example
	@{b=0;c=3},@{c=4;d=5} |Merge-Dictionary.ps1 @{a=1;b=2} -Force |foreach {$_ |ConvertTo-Json -Compress}

	{"c":3,"b":0,"a":1}
	{"d":5,"b":2,"c":4,"a":1}

.Example
	@{b=0;c=3},@{c=4;d=5} |Merge-Dictionary.ps1 @{a=1;b=2} -Force -Accumulate |foreach {$_ |ConvertTo-Json -Compress}

	{"c":3,"b":0,"a":1}
	{"c":4,"b":0,"d":5,"a":1}

.Example
	@{b=0;c=3},@{c=4;d=5} |Merge-Dictionary.ps1 -Accumulate |select -Last 1

	Name                           Value
	----                           -----
	c                              3
	b                              0
	d                              5
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Collections.IDictionary])] Param(
[Parameter(Position=0)][Collections.IDictionary] $ReferenceObject = @{},
[Parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true)][Collections.IDictionary] $InputObject,
[switch] $Accumulate,
[switch] $Force
)
Begin {if($Accumulate) {$value = $ReferenceObject.Clone()}}
Process
{
	if(!$Accumulate) {$value = $ReferenceObject.Clone()}
	foreach($key in $InputObject.Keys)
	{
		if(!$value.ContainsKey($key)) {$value.Add($key,$InputObject[$key])}
		elseif($Force) {$value[$key] = $InputObject[$key]}
	}
	return $value
}
