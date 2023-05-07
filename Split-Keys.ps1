<#
.SYNOPSIS
Clones a dictionary keeping only the specified keys.

.NOTES
Only string keys are supported.

.INPUTS
System.Collections.IDictionary, the source dictionary to select key-value pairs from by key.

.OUTPUTS
System.Collections.Specialized.OrderedDictionary, the dictionary matching key-value pairs are copied to.

.FUNCTIONALITY
Dictionary

.LINK
https://msdn.microsoft.com/library/System.Collections.IDictionary.aspx

.EXAMPLE
@{ A = 1; B = 2; C = 3 } |Split-Keys.ps1 B C D

Name Value
---- -----
B    2
C    3

.EXAMPLE
$PSBoundParameters |Split-Keys.ps1 From To Cc Bcc Subject -SkipNullValues |Send-MailMessage

Sends an email using selected params declared by the calling script with values.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Collections.IDictionary])] Param(
# List of keys to include in the new dictionary.
[Parameter(Position=0,ValueFromRemainingArguments=$true)][string[]] $Keys,
# The source dictionary to copy key-value pairs from.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][Alias('Hashtable')][Collections.IDictionary] $Dictionary,
# When present, indicates that key-value pairs with a null value should not be included.
[Alias('NoNulls')][switch] $SkipNullValues
)
Begin
{
	$getKeys = [Collections.IDictionary].GetProperty('Keys').GetGetMethod()
	function Get-Key($dict) { return $getKeys.Invoke($dict, @()) }

	$removeKey = [Collections.IDictionary].GetMethod('Remove')
	function Remove-Key($dict, $key) { [void]$removeKey.Invoke($dict, @($key)) }
}
Process
{
	if($null -eq $Dictionary) {return @{}}
	$selected = $Dictionary.Clone()
	foreach($key in Get-Keys $Dictionary)
	{
		if($key -in $Keys) {continue}
		$value = $Dictionary[$key]
		if($null -eq $value) {if(!$SkipNullValues) {continue}}
		elseif($value -is [switch]) {if($value.IsPresent) {continue}}
		Remove-Key $selected $key
	}
	return $selected
}
