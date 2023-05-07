<#
.SYNOPSIS
Sends emails from a drop folder using .NET config defaults.

.INPUTS
System.IO.FileInfo of .eml files to send.

.COMPONENT
ADODB.Stream

.COMPONENT
CDO.Message

.LINK
Send-MailMessage

.LINK
Use-NetMailConfig.ps1

.EXAMPLE
Send-MailMessageFile.ps1

Sends all .eml files in the current directory.

.EXAMPLE
ls C:\Inetpub\mailroot\*.eml |Send-MailMessageFile.ps1

Sends emails from drop directory.
#>

#Requires -Version 3
[CmdletBinding(SupportsShouldProcess=$true)][OutputType([void])] Param(
# The .eml file to parse and send.
[Parameter(Position=0,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)]
[Alias('Eml')][IO.FileInfo[]]$MailFile = (Get-ChildItem *.eml),
# Indicates sent files should be deleted.
[switch]$Delete
)
Begin { Use-NetMailConfig.ps1 }
Process
{
    foreach($file in $MailFile)
    {
        $stream = New-Object -ComObject ADODB.Stream
        [void]$stream.Open([Type]::Missing,0,-1,'','')
        [void]$stream.LoadFromFile($file.FullName)
        [void]$stream.Flush()
        $eml = New-Object -ComObject CDO.Message
        $eml.DataSource.OpenObject($stream,'_Stream')
        $eml.DataSource.Save()
        $stream.Close()
        $to = New-Object Net.Mail.MailAddressCollection
        $to.Add($eml.To)
        $msg = @{ From = $eml.From; To = $to |ForEach-Object {"$_"}; Subject = $eml.Subject }
        if($eml.CC)
        {
            $cc = New-Object Net.Mail.MailAddressCollection
            $cc.Add($eml.CC)
            [void]$msg.Add('Cc',($cc |ForEach-Object {"$_"}))
        }
        if($eml.BCC)
        {
            $bcc = New-Object Net.Mail.MailAddressCollection
            $bcc.Add($eml.BCC)
            [void]$msg.Add('Bcc',($bcc |ForEach-Object {"$_"}))
        }
        $priority = try{$msg.Fields('urn:schemas:mailheader:importance').Value}catch{}
        if($priority) {[void]$msg.Add('Priority',$priority)}
        if($eml.HTMLBody) {[void]$msg.Add('Body',$eml.HTMLBody);[void]$msg.Add('BodyAsHtml',$true)}
        else {[void]$msg.Add('Body',$eml.TextBody)}
        [string[]]$atts =
            if($eml.Attachments.Count) {$eml.Attachments |ForEach-Object {$f = "$env:TEMP\$([guid]::NewGuid())"; $_.SaveToFile($f); $f}}
            else {@()}
        if($atts) {[void]$msg.Add('Attachments',$atts)}
        if($PSCmdlet.ShouldProcess("email $file ($($eml.Subject))",'Send')) {Send-MailMessage @msg}
        if($atts) {$atts |Remove-Item}
        if($Delete) {Remove-Item $file.FullName}
    }
}

