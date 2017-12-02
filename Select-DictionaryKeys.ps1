<#
.Synopsis
    Constructs an OrderedDictionary by selecting keys from a given IDictionary.

.Parameter Keys
    List of keys to include in the new dictionary.

.Parameter Dictionary
    The source dictionary to copy key-value pairs from.

.Parameter SkipNullValues
    When present, indicates that key-value pairs with a null value should not be included.

.Notes
    Only string keys are supported.

.Inputs
    System.Collections.IDictionary, the source dictionary to select key-value pairs from by key. 

.Outputs
    System.Collections.Specialized.OrderedDictionary, the dictionary matching key-value pairs are copied to.

.Link
    https://msdn.microsoft.com/library/System.Collections.IDictionary.aspx

.Example
    @{ A = 1; B = 2; C = 3 } |Select-DictionaryKeys.ps1 B D

    Name Value
    ---- -----
    B    2

.Example
    $PSBoundParameters |Select-DictionaryKeys.ps1 From To Cc Bcc Subject -SkipNullValues |Send-MailMessage

    Sends an email using selected params declared by the calling script with values.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Collections.Specialized.OrderedDictionary])] Param(
[Parameter(Position=0,ValueFromRemainingArguments=$true)][string[]]$Keys,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][Alias('Hashtable')][Collections.IDictionary]$Dictionary,
[Alias('NoNulls')][switch]$SkipNullValues
)
Begin {$containsKey = [Collections.IDictionary].GetMethod('Contains')}
Process
{
    $selected = [ordered]@{}
    if(!$Dictionary -or $Dictionary.Count -eq 0){Write-Verbose 'Dictionary is null or empty!'; return $selected}
    foreach($key in $Keys)
    {
        if(!($containsKey.Invoke($Dictionary,@($key)))){continue}
        $value = $Dictionary[$key]
        if($SkipNullValues -and $value -eq $null){continue}
        if($value -is [switch] -and $value.IsPresent){[void]$selected.Add($key,$value.ToBool())}
        [void]$selected.Add($key,$value)
    }
    $selected
}
