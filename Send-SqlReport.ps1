<#
.Synopsis
    Execute a SQL statement and email the results.

.Parameter Subject
    The email subject.

.Parameter To
    The email address(es) to send the results to.

.Parameter ConnectionName
    The connection string name to use when executing the query.

.Parameter Sql
    The SQL statement to execute.

.Parameter From
    The from address to use for the email.
    The default is to use the value from the configuration value:

    <system.net>
        <mailSettings>
          <smtp from="source@example.org" deliveryMethod="network">
		      <network host="mail.example.org" />
          </smtp>
        </mailSettings>
    </system.net>

.Parameter Timeout
    The timeout to use for the query, in seconds. The default is 90.

.Parameter PreContent
    HTML content to insert into the email before the query results.

.Parameter PostContent
    HTML content to insert into the email after the query results.

.Parameter Cc
    The email address(es) to CC the results to.

.Parameter Bcc
    The email address(es) to BCC the results to.

.Parameter Priority
    The priority of the email, one of: High, Low, Normal
#>

#requires -version 2
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='None')] Param(
[Parameter(Position=0,Mandatory=$true)][string]$Subject,
[Parameter(Position=1,Mandatory=$true)][string[]]$To,
[Parameter(Position=2,Mandatory=$true)][string]$ConnectionName,
[Parameter(Position=3,Mandatory=$true)][string]$Sql,
[string]$From,
[int]$Timeout= 90,
[string]$PreContent= ' ',
[string]$PostContent= ' ',
[string[]]$Cc,
[string[]]$Bcc,
[Net.Mail.MailPriority]$Priority,
[uri]$SeqUrl = 'https://seqlog/'
)
try{[void][Configuration.ConfigurationManager]}catch{Add-Type -as System.Configuration} # get access to the config connection strings
Use-SeqServer.ps1 $SeqUrl
try
{
    $at =
        if(Get-Command Get-ADUser -ErrorAction SilentlyContinue)
        {
            [Net.Mail.MailAddress]$email = Get-ADUser -Properties mail |% mail
            if($email.Host) {'@' + $email.Host}
        }
    if($at)
    {
        $To = $To |% { if($_ -like '*@*'){$_}else{"$_$at"} } # allow username-only emails
        $Cc = $Cc |% { if($_ -like '*@*'){$_}elseif($_){"$_$at"} } # allow username-only emails
        if($Bcc) { $Bcc = $Bcc |% { if($_ -like '*@*'){$_}else{"$_$at"} } } # allow username-only emails
    }
}
catch
{
    Send-SeqScriptEvent.ps1 'Getting email address' $_ Warning -InvocationScope 2
}
if(!$From)
{
    try{[Configuration.ConfigurationManager]|Out-Null}catch{Add-Type -AN System.Configuration}
    try{$From=[Configuration.ConfigurationManager]::GetSection('system.net/mailSettings/smtp').From}
    catch{Send-SeqScriptEvent.ps1 'Getting from address' $_ Warning -InvocationScope 2}
}
if(!$PSEmailServer)
{
    try{$PSEmailServer=[Configuration.ConfigurationManager]::GetSection('system.net/mailSettings/smtp/network').Host}
    catch{Send-SeqScriptEvent.ps1 'Getting email server' $_ Warning -InvocationScope 2}
}
try
{
    $cmd = New-Object Data.SqlClient.SqlCommand $Sql,(New-Object Data.SqlClient.SqlConnection ([Configuration.ConfigurationManager]::ConnectionStrings[$ConnectionName].ConnectionString))
    $cmd.CommandTimeout = $Timeout
    $cmd.Connection.Open() # open the database connection
    $data = New-Object Data.DataTable
    $data.Load($cmd.ExecuteReader()) # read the results into a table
    $cmd.Connection.Dispose() ; $cmd.Dispose() # release all database resources
    $data |Format-Table |Out-String |Write-Verbose
    if($data.Rows.Count -eq 0) # no rows
    {
        Write-Verbose "No rows returned."
        Write-EventLog -LogName Application -Source Reporting -EventId 100 -Message "No rows returned for $Subject"
    }
    else
    { # convert the table into HTML (select away the add'l properties the DataTable adds), add some Outlook 2007-compat CSS, email it
        $odd = $false
        $Msg = @{
            To = $To
            Subject = $Subject
            BodyAsHtml = $true
            SmtpServer = $PSEmailServer
            Body = ($(( `
                        $data |select ($data.Columns|%{$_.ColumnName}) |ConvertTo-Html -PreContent $PreContent -PostContent $PostContent `
                -Head '<style type="text/css">th,td {padding:2px 1ex 0 2px}</style>' |
                        % {if($odd=!$odd){$_ -replace '^<tr>','<tr style="background:#EEE">'}else{$_}} ) -join '' `
                                -replace '<td>(\d+(\.\d+)?)</td>','<td align="right">$1</td>') `
                                -replace '<table>','<table cellpadding="2" cellspacing="0" style="font:x-small ''Lucida Console'',monospace">')
        }
        if($From) { $Msg.From= $From }
        if($Cc) { $Msg.Cc= $Cc }
        if($Bcc) { $Msg.Bcc= $Bcc }
        if($Priority) { $Msg.Priority= $Priority }
        if($PSCmdlet.ShouldProcess("Message:`n$(New-Object PSObject -Property $Msg|Format-List|Out-String)`n",'Send message'))
        { Send-MailMessage @Msg } # splat the arguments hashtable
    }
}
catch # report problems
{
    Write-Warning $_
    Write-EventLog -LogName Application -Source Reporting -EventId 99 -EntryType Error -Message $_
    if($SeqUrl) { Send-SeqScriptEvent.ps1 'Reporting' $_ Error -InvocationScope 2 }
    # consciously omitting Cc & Bcc
    $Msg = @{
        To = $To
        Subject = "$Subject [Error]"
        BodyAsHtml = $false
        SmtpServer = $PSEmailServer
        Body = $_
    }
    if($From) { $Msg.From= $From }
    if($Priority) { $Msg.Priority= $Priority }
    if($PSCmdlet.ShouldProcess("Message:`n$(New-Object PSObject -Property $Msg|Format-List|Out-String)`n",'Send message'))
    { Send-MailMessage @Msg }
}
