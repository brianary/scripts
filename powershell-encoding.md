PowerShell Encoding
===================

In versions prior to [PowerShell Core 6's cleanup][PSC6enc], PowerShell encoding is kind of a mess.

[PSC6enc]: https://docs.microsoft.com/powershell/scripting/whats-new/what-s-new-in-powershell-core-60#default-encoding-is-utf-8-without-a-bom "Default encoding is UTF-8 without a BOM"

Using PowerShell 5.1.14409.1012 with version 3.1 of Microsoft.PowerShell.Management and Microsoft.PowerShell.Utility,
let's list all the cmdlets that have an "Encoding" parameter, plus the type and default of that parameter:

```powershell
gcm |
    ? {$_.Parameters} |
    ? {$_.Parameters.ContainsKey('Encoding')} |
    % {[pscustomobject]@{
        CommandName  = $_.Name
        EncodingType = ([type]$_.Parameters.Encoding.ParameterType).Name # for brevity
        Default      = ((((help $_.Name -Parameter Encoding |select -Skip 2 |% {$_.Trim()}) -join "`n"
        ) -replace '\n(?=\w)','') -split '\n+' |sls '(?m)^(?!--|Required).*default.*') -join ' '
    }} |
    sort CommandName |
    ft -auto -Wrap
```

```text
CommandName      EncodingType                     Default
-----------      ------------                     -------
Add-Content      FileSystemCmdletProviderEncoding
Export-Clixml    String                           The default value is Unicode.
Export-Csv       String                           The default value is ASCII.
Export-PSSession String                           The default value is UTF-8.
Format-Hex       String                           The default value is Unicode.
Get-Content      FileSystemCmdletProviderEncoding
Import-Csv       String                           The default is ASCII.
Out-File         String                           Unicode is the default. Default uses the encoding of the system's
                                                  current ANSI code page.
Select-String    String                           Specifies the character encoding that Select-String should assume
                                                  when searching the file. The default is UTF8. Default is the encoding
                                                  of the system's current ANSI code page. OEM is the current original
                                                  equipment manufacturer code page identifier for the operating system.
Send-MailMessage Encoding                         ASCII is the default.
Set-Content      FileSystemCmdletProviderEncoding The default value is ASCII.
```

We used **Get-Help** to parse the text description of the parameter defaults with that terrible knot of code.

Those defaults are definitely not… harmonius:
ASCII, utf-8, "ANSI"/"OEM" (depending on your locale), and "Unicode" (which is really utf-16).
**Select-String** lists two conflicting defaults in the help!

Not even the types of these parameters are in agreement!
Some string names, some **System.Text.Encoding** objects (which can be converted from a name), but also an enumeration.

Let's get the values available for that enumeration using
[**Get-EnumValues.ps1**](https://github.com/brianary/scripts/blob/master/Get-EnumValues.ps1):

```powershell
Get-EnumValues.ps1 Microsoft.Powershell.Commands.FileSystemCmdletProviderEncoding
```

```text
Value Name
----- ----
    0 Unknown
    1 String
    2 Unicode
    3 Byte
    4 BigEndianUnicode
    5 UTF8
    6 UTF7
    7 UTF32
    8 Ascii
    9 Default
   10 Oem
   11 BigEndianUTF32
```

Will the new PowerShell Core 6 `UTF8NoBOM` encoding default mean all these cmdlets use a string parameter value now?
