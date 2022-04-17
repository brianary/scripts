<#
.SYNOPSIS
Execute a SQL statement and email the results.

.PARAMETER Subject
The email subject.

.PARAMETER To
The email address(es) to send the results to.

.PARAMETER Sql
The SQL statement to execute.

.PARAMETER ServerInstance
The name of a server (and optional instance) to connect and use for the query.

.PARAMETER Database
The the database to connect to on the server.

.PARAMETER ConnectionString
Specifies a connection string to connect to the server.

.PARAMETER ConnectionName
The connection string name from the ConfigurationManager to use when executing the query.

.PARAMETER EmptySubject
The subject line for the email when no data is returned.

.PARAMETER From
The from address to use for the email.
The default is to use $PSEmailServer.
If that is missing, it will be populated by the value from the
configuration value:

| <system.net>
|   <mailSettings>
|     <smtp from="source@example.org" deliveryMethod="network">
|       <network host="mail.example.org" enableSsl="true" />
|     </smtp>
|   </mailSettings>
| </system.net>

(If enableSsl is set to true, SSL will be used to send the report.)

.PARAMETER Caption
The optional table caption to add.

.PARAMETER ReportFile
A UNC path to a .csv or .tsv file writable by the script and readable by the email recipient to output the data to,
which will be linked in the email rather than included in the email body.

Supports a format template for the current date and time (e.g. {0:yyyyMMddHHmmss}).

.PARAMETER Timeout
The timeout to use for the query, in seconds. The default is 90.

.PARAMETER PreContent
HTML content to insert into the email before the query results.

.PARAMETER PostContent
HTML content to insert into the email after the query results.

.PARAMETER Cc
The email address(es) to CC the results to.

.PARAMETER Bcc
The email address(es) to BCC the results to.

.PARAMETER Priority
The priority of the email, one of: High, Low, Normal

.PARAMETER UseSsl
Indicates that SSL should be used when sending the message.

(See the From parameter for an alternate SSL flag.)

.LINK
Use-SqlcmdParams.ps1

.LINK
Send-MailMessage

.LINK
Invoke-Sqlcmd
#>

#Requires -Version 3
#Requires -Module SqlServer
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='None')][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true)][string]$Subject,
[Parameter(Position=1,Mandatory=$true)][string[]]$To,
[Parameter(Position=2,Mandatory=$true)][string]$Sql,
[Parameter(ParameterSetName='ByConnectionParameters',Position=3)][string]$ServerInstance,
[Parameter(ParameterSetName='ByConnectionParameters',Position=4)][string]$Database,
[Parameter(ParameterSetName='ByConnectionString',Mandatory=$true)][string]$ConnectionString,
[Parameter(ParameterSetName='ByConnectionName',Mandatory=$true)][string]$ConnectionName,
[string]$EmptySubject,
[string]$From,
[string]$Caption,
[string]$ReportFile,
[Alias('Timeout')][int]$QueryTimeout= 90,
[string]$PreContent= ' ',
[string]$PostContent= ' ',
[string[]]$Cc,
[string[]]$Bcc,
[Net.Mail.MailPriority]$Priority,
[switch]$UseSsl,
[uri]$SeqUrl = $PSDefaultParameterValues['Send-SeqEvent.ps1:Server']
)

Use-NetMailConfig.ps1
Use-SqlcmdParams.ps1
if($SeqUrl){Use-SeqServer.ps1 $SeqUrl}

# use the default From host for emails without a host
$mailhost = ([Net.Mail.MailAddress]$PSDefaultParameterValues['Send-MailMessage:From']).Host |Out-String
if($mailhost)
{
    $To = $To |% { if($_ -like '*@*'){$_}else{"$_@$mailhost"} } # allow username-only emails
    $Cc = $Cc |% { if($_ -like '*@*'){$_}elseif($_){"$_@$mailhost"} } # allow username-only emails
    if($Bcc) { $Bcc = $Bcc |% { if($_ -like '*@*'){$_}else{"$_@$mailhost"} } } # allow username-only emails
}

$Msg = @{
    To         = $To
    Subject    = $Subject
    BodyAsHtml = $true
    SmtpServer = $PSEmailServer
}
if($From)     { $Msg.From= $From }
if($Cc)       { $Msg.Cc= $Cc }
if($Bcc)      { $Msg.Bcc= $Bcc }
if($Priority) { $Msg.Priority= $Priority }
if($UseSsl)   { $Msg.UseSsl = $true }

try
{
    $query = @{ Query = $Sql }
    [psobject[]]$data = Invoke-Sqlcmd @query -ErrorAction Stop |ConvertFrom-DataRow.ps1
    $data |Format-Table |Out-String |Write-Verbose
    if(!$data -or $data.Length -eq 0) # no rows
    {
        Write-Verbose "No rows returned."
        if($SeqUrl) { Send-SeqEvent.ps1 'No rows returned for {Subject}' @{Subject=$Subject} -Level Information }
        if($EmptySubject) { $Msg.Subject = $EmptySubject; Send-MailMessage @Msg  }
        return
    }
    Write-Verbose "$($data.Length) rows returned."
    if($ReportFile)
    { # convert the table into a tsv/csv file and link to it
        $ReportFile = $ReportFile -f (Get-Date)
        if($ReportFile -like '*.tsv') {$data |Export-Csv $ReportFile -Delimiter "`t" -Encoding UTF8 -NoTypeInformation}
        else {$data |Export-Csv $ReportFile -Encoding UTF8 -NoTypeInformation}
        $ReportFile = (Resolve-Path $ReportFile).ProviderPath
        if(([uri]$ReportFile).IsUnc)
        {
            $Msg.Add('Body',@"
$PreContent
<a href=`"$([Net.WebUtility]::HtmlEncode($ReportFile))`">$([Net.WebUtility]::HtmlEncode((Split-Path $ReportFile -Leaf)))</a>
$PostContent
"@)
        }
        else
        {
            $Msg.Add('Body',"$PreContent`n$PostContent")
            $Msg.Add('Attachments',$ReportFile)
        }
    }
    else
    { # convert the table into HTML (select away the add'l properties the DataTable adds), add some Outlook 2007-compat CSS, email it
        $tableFormat = @{OddRowBackground='#EEE'}
        if($Caption){$tableFormat.Add('Caption',$Caption)}
        $Msg.Add('Body',($data |
            ConvertTo-Html -PreContent $PreContent -PostContent $PostContent -Head '<style type="text/css">th,td {padding:2px 1ex 0 2px}</style>' |
            Format-HtmlDataTable.ps1 @tableFormat |
            Out-String))
    }
    if($PSCmdlet.ShouldProcess("Message:`n$(New-Object PSObject -Property $Msg|Format-List|Out-String)`n",'Send message'))
    { Send-MailMessage @Msg } # splat the arguments hashtable
}
catch # report problems
{
    Write-Warning $_
    if($SeqUrl) { Send-SeqScriptEvent.ps1 'Reporting' -InvocationScope 2 }
    # consciously omitting Cc & Bcc
    $Msg = @{
        To         = $To
        Subject    = "$Subject [Error]"
        BodyAsHtml = $false
        SmtpServer = $PSEmailServer
        Body       = $_
    }
    if($From) { $Msg.From= $From }
    if($Priority) { $Msg.Priority= $Priority }
    if($PSCmdlet.ShouldProcess("Message:`n$(New-Object PSObject -Property $Msg|Format-List|Out-String)`n",'Send message'))
    { Send-MailMessage @Msg }
    Stop-ThrowError.ps1 "$_" -OperationContext $_
}
