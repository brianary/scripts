<#
.Synopsis
    Creates multipart/form-data to send as a request body.

.Parameter Fields
    The fields to pass, as a Hashtable or other dictionary.
    Values of the System.IO.FileInfo type will be read, as for a file upload.

.Link
    https://docs.microsoft.com/dotnet/api/system.net.http.multipartformdatacontent

.Link
    Invoke-WebRequest

.Link
    Invoke-RestMethod

.Link
    New-Guid

.Example
    @{ title = 'Name'; file = Get-Item avartar.png } |ConvertTo-MultipartFormData.ps1 |Invoke-WebRequest $url -Method POST

    Sends two fields, one of which is a file upload.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][Collections.IDictionary] $Fields
)
DynamicParam
{
    $boundary = "$(New-Guid)"
    $PSDefaultParameterValues['Invoke-WebRequest:ContentType'] = "multipart/form-data; boundary=$boundary"
    $PSDefaultParameterValues['Invoke-RestMethod:ContentType'] = "multipart/form-data; boundary=$boundary"
}
Begin
{
    if((Get-Module Microsoft.PowerShell.Utility).Version -ge [version]6.1)
    {
        Write-Warning "Invoke-WebRequest and Invoke-RestMethod appear to natively support multipart/form-data."
    }
    try{[void][Net.Http.StringContent]}catch{Add-Type -AN System.Net.Http |Out-Null}
}
Process
{
    $content = New-Object Net.Http.MultipartFormDataContent $boundary
    foreach($field in $Fields.GetEnumerator())
    {
        if($field.Value -isnot [IO.FileInfo]) {$content.Add([Net.Http.StringContent]$field.Value,$field.Key)}
        else
        {
            Write-Verbose "Adding file $($field.Value.FullName)"
            $content.Add([Net.Http.StreamContent]$field.Value.OpenRead(),$field.Key,$field.Value.Name)
        }
    }
    [Threading.Tasks.Task[string]]$getbody = $content.ReadAsStringAsync()
    $getbody.Wait()
    [string]$body = $getbody.Result
    $content.Dispose()
    return $body
}
End
{
    $PSDefaultParameterValues.Remove('Invoke-WebRequest:ContentType')
    $PSDefaultParameterValues.Remove('Invoke-RestMethod:ContentType')
}
