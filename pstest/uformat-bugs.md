Get-Date -UFormat bugs
======================

Get-Date -UFormat %c does not match reference implementation
--------------------

### Repro

Get-Date -UFormat %c

Currently, `"{0:ddd} {0:dd} {0:MMM} {0:yyyy} {0:HH}:{0:mm}:{0:ss}"` is [being used](https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L421), but `"{0:ddd} {0:MMM} {0,2:%d} {0:HH}:{0:mm}:{0:ss} {0:yyyy}"` is a better match. See [Date conversion specifiers](https://www.gnu.org/software/coreutils/manual/html_node/Date-conversion-specifiers.html) or [strftime](https://pubs.opengroup.org/onlinepubs/9699919799/functions/strftime.html).

### Expected

Based on running the `date -d $date +%c` as a reference implementation (see Environment for details).

PS> Get-Date 1999-01-01 -UFormat %c
Fri Jan  1 00:00:00 1999
PS> Get-Date 2000-02-14 -UFormat %c
Mon Feb 14 00:00:00 2000
PS> Get-Date 2001-03-29 -UFormat %c
Thu Mar 29 00:00:00 2001
PS> Get-Date 2002-05-12 -UFormat %c
Sun May 12 00:00:00 2002
PS> Get-Date 2003-06-25 -UFormat %c
Wed Jun 25 00:00:00 2003
PS> Get-Date 2004-08-07 -UFormat %c
Sat Aug  7 00:00:00 2004
PS> Get-Date 2005-09-20 -UFormat %c
Tue Sep 20 00:00:00 2005
PS> Get-Date 2006-11-03 -UFormat %c
Fri Nov  3 00:00:00 2006
PS> Get-Date 2007-12-17 -UFormat %c
Mon Dec 17 00:00:00 2007
PS> Get-Date 2009-01-29 -UFormat %c
Thu Jan 29 00:00:00 2009
PS> Get-Date 2010-03-14 -UFormat %c
Sun Mar 14 00:00:00 2010
PS> Get-Date 2011-04-27 -UFormat %c
Wed Apr 27 00:00:00 2011
PS> Get-Date 2012-06-09 -UFormat %c
Sat Jun  9 00:00:00 2012
PS> Get-Date 2013-07-23 -UFormat %c
Tue Jul 23 00:00:00 2013
PS> Get-Date 2014-09-05 -UFormat %c
Fri Sep  5 00:00:00 2014
PS> Get-Date 2015-10-19 -UFormat %c
Mon Oct 19 00:00:00 2015
PS> Get-Date 2016-12-01 -UFormat %c
Thu Dec  1 00:00:00 2016
PS> Get-Date 2018-01-14 -UFormat %c
Sun Jan 14 00:00:00 2018
PS> Get-Date 2019-02-27 -UFormat %c
Wed Feb 27 00:00:00 2019
PS> Get-Date 2020-04-11 -UFormat %c
Sat Apr 11 00:00:00 2020

### Actual

PS> Get-Date 1999-01-01 -UFormat %c
Fri 01 Jan 1999 00:00:00
PS> Get-Date 2000-02-14 -UFormat %c
Mon 14 Feb 2000 00:00:00
PS> Get-Date 2001-03-29 -UFormat %c
Thu 29 Mar 2001 00:00:00
PS> Get-Date 2002-05-12 -UFormat %c
Sun 12 May 2002 00:00:00
PS> Get-Date 2003-06-25 -UFormat %c
Wed 25 Jun 2003 00:00:00
PS> Get-Date 2004-08-07 -UFormat %c
Sat 07 Aug 2004 00:00:00
PS> Get-Date 2005-09-20 -UFormat %c
Tue 20 Sep 2005 00:00:00
PS> Get-Date 2006-11-03 -UFormat %c
Fri 03 Nov 2006 00:00:00
PS> Get-Date 2007-12-17 -UFormat %c
Mon 17 Dec 2007 00:00:00
PS> Get-Date 2009-01-29 -UFormat %c
Thu 29 Jan 2009 00:00:00
PS> Get-Date 2010-03-14 -UFormat %c
Sun 14 Mar 2010 00:00:00
PS> Get-Date 2011-04-27 -UFormat %c
Wed 27 Apr 2011 00:00:00
PS> Get-Date 2012-06-09 -UFormat %c
Sat 09 Jun 2012 00:00:00
PS> Get-Date 2013-07-23 -UFormat %c
Tue 23 Jul 2013 00:00:00
PS> Get-Date 2014-09-05 -UFormat %c
Fri 05 Sep 2014 00:00:00
PS> Get-Date 2015-10-19 -UFormat %c
Mon 19 Oct 2015 00:00:00
PS> Get-Date 2016-12-01 -UFormat %c
Thu 01 Dec 2016 00:00:00
PS> Get-Date 2018-01-14 -UFormat %c
Sun 14 Jan 2018 00:00:00
PS> Get-Date 2019-02-27 -UFormat %c
Wed 27 Feb 2019 00:00:00
PS> Get-Date 2020-04-11 -UFormat %c
Sat 11 Apr 2020 00:00:00

### Environment

Name                           Value
----                           -----
PSVersion                      7.4.0
PSEdition                      Core
GitCommitId                    7.4.0
OS                             Microsoft Windows 10.0.22621
Platform                       Win32NT
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0

WSL Ubuntu details:

$ uname -a
Linux localhost 5.15.133.1-microsoft-standard-WSL2 #1 SMP Thu Oct 5 21:02:42 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

Get-Date -UFormat %D does not match reference implementation
--------------------

### Repro

Get-Date -UFormat %D

Currently, `"{0:MM/dd/yy}"` is [being used](https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L425), but `"{0:MM\/dd\/yy}"` is a better match. See [Date conversion specifiers](https://www.gnu.org/software/coreutils/manual/html_node/Date-conversion-specifiers.html) or [strftime](https://pubs.opengroup.org/onlinepubs/9699919799/functions/strftime.html).

### Expected

Based on running the `date -d $date +%D` as a reference implementation (see Environment for details).

PS> Get-Date 1999-01-01 -UFormat %D
01/01/99
PS> Get-Date 2000-02-14 -UFormat %D
02/14/00
PS> Get-Date 2001-03-29 -UFormat %D
03/29/01
PS> Get-Date 2002-05-12 -UFormat %D
05/12/02
PS> Get-Date 2003-06-25 -UFormat %D
06/25/03
PS> Get-Date 2004-08-07 -UFormat %D
08/07/04
PS> Get-Date 2005-09-20 -UFormat %D
09/20/05
PS> Get-Date 2006-11-03 -UFormat %D
11/03/06
PS> Get-Date 2007-12-17 -UFormat %D
12/17/07
PS> Get-Date 2009-01-29 -UFormat %D
01/29/09
PS> Get-Date 2010-03-14 -UFormat %D
03/14/10
PS> Get-Date 2011-04-27 -UFormat %D
04/27/11
PS> Get-Date 2012-06-09 -UFormat %D
06/09/12
PS> Get-Date 2013-07-23 -UFormat %D
07/23/13
PS> Get-Date 2014-09-05 -UFormat %D
09/05/14
PS> Get-Date 2015-10-19 -UFormat %D
10/19/15
PS> Get-Date 2016-12-01 -UFormat %D
12/01/16
PS> Get-Date 2018-01-14 -UFormat %D
01/14/18
PS> Get-Date 2019-02-27 -UFormat %D
02/27/19
PS> Get-Date 2020-04-11 -UFormat %D
04/11/20

### Actual

PS> Get-Date 1999-01-01 -UFormat %D
01-01-99
PS> Get-Date 2000-02-14 -UFormat %D
02-14-00
PS> Get-Date 2001-03-29 -UFormat %D
03-29-01
PS> Get-Date 2002-05-12 -UFormat %D
05-12-02
PS> Get-Date 2003-06-25 -UFormat %D
06-25-03
PS> Get-Date 2004-08-07 -UFormat %D
08-07-04
PS> Get-Date 2005-09-20 -UFormat %D
09-20-05
PS> Get-Date 2006-11-03 -UFormat %D
11-03-06
PS> Get-Date 2007-12-17 -UFormat %D
12-17-07
PS> Get-Date 2009-01-29 -UFormat %D
01-29-09
PS> Get-Date 2010-03-14 -UFormat %D
03-14-10
PS> Get-Date 2011-04-27 -UFormat %D
04-27-11
PS> Get-Date 2012-06-09 -UFormat %D
06-09-12
PS> Get-Date 2013-07-23 -UFormat %D
07-23-13
PS> Get-Date 2014-09-05 -UFormat %D
09-05-14
PS> Get-Date 2015-10-19 -UFormat %D
10-19-15
PS> Get-Date 2016-12-01 -UFormat %D
12-01-16
PS> Get-Date 2018-01-14 -UFormat %D
01-14-18
PS> Get-Date 2019-02-27 -UFormat %D
02-27-19
PS> Get-Date 2020-04-11 -UFormat %D
04-11-20

### Environment

Name                           Value
----                           -----
PSVersion                      7.4.0
PSEdition                      Core
GitCommitId                    7.4.0
OS                             Microsoft Windows 10.0.22621
Platform                       Win32NT
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0

WSL Ubuntu details:

$ uname -a
Linux localhost 5.15.133.1-microsoft-standard-WSL2 #1 SMP Thu Oct 5 21:02:42 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

Get-Date -UFormat %q does not match reference implementation
--------------------

### Repro

Get-Date -UFormat %q

This is not currently implemented, but could be added as `(dateTime.Month-1)/3+1` or `1+int.DivRem(dateTime.Month-1, 3).Quotient`. See [Date conversion specifiers](https://www.gnu.org/software/coreutils/manual/html_node/Date-conversion-specifiers.html) or [strftime](https://pubs.opengroup.org/onlinepubs/9699919799/functions/strftime.html).

### Expected

Based on running the `date -d $date +%q` as a reference implementation (see Environment for details).

PS> Get-Date 1999-01-01 -UFormat %q
1
PS> Get-Date 2000-02-14 -UFormat %q
1
PS> Get-Date 2001-03-29 -UFormat %q
1
PS> Get-Date 2002-05-12 -UFormat %q
2
PS> Get-Date 2003-06-25 -UFormat %q
2
PS> Get-Date 2004-08-07 -UFormat %q
3
PS> Get-Date 2005-09-20 -UFormat %q
3
PS> Get-Date 2006-11-03 -UFormat %q
4
PS> Get-Date 2007-12-17 -UFormat %q
4
PS> Get-Date 2009-01-29 -UFormat %q
1
PS> Get-Date 2010-03-14 -UFormat %q
1
PS> Get-Date 2011-04-27 -UFormat %q
2
PS> Get-Date 2012-06-09 -UFormat %q
2
PS> Get-Date 2013-07-23 -UFormat %q
3
PS> Get-Date 2014-09-05 -UFormat %q
3
PS> Get-Date 2015-10-19 -UFormat %q
4
PS> Get-Date 2016-12-01 -UFormat %q
4
PS> Get-Date 2018-01-14 -UFormat %q
1
PS> Get-Date 2019-02-27 -UFormat %q
1
PS> Get-Date 2020-04-11 -UFormat %q
2

### Actual

PS> Get-Date 1999-01-01 -UFormat %q
q
PS> Get-Date 2000-02-14 -UFormat %q
q
PS> Get-Date 2001-03-29 -UFormat %q
q
PS> Get-Date 2002-05-12 -UFormat %q
q
PS> Get-Date 2003-06-25 -UFormat %q
q
PS> Get-Date 2004-08-07 -UFormat %q
q
PS> Get-Date 2005-09-20 -UFormat %q
q
PS> Get-Date 2006-11-03 -UFormat %q
q
PS> Get-Date 2007-12-17 -UFormat %q
q
PS> Get-Date 2009-01-29 -UFormat %q
q
PS> Get-Date 2010-03-14 -UFormat %q
q
PS> Get-Date 2011-04-27 -UFormat %q
q
PS> Get-Date 2012-06-09 -UFormat %q
q
PS> Get-Date 2013-07-23 -UFormat %q
q
PS> Get-Date 2014-09-05 -UFormat %q
q
PS> Get-Date 2015-10-19 -UFormat %q
q
PS> Get-Date 2016-12-01 -UFormat %q
q
PS> Get-Date 2018-01-14 -UFormat %q
q
PS> Get-Date 2019-02-27 -UFormat %q
q
PS> Get-Date 2020-04-11 -UFormat %q
q

### Environment

Name                           Value
----                           -----
PSVersion                      7.4.0
PSEdition                      Core
GitCommitId                    7.4.0
OS                             Microsoft Windows 10.0.22621
Platform                       Win32NT
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0

WSL Ubuntu details:

$ uname -a
Linux localhost 5.15.133.1-microsoft-standard-WSL2 #1 SMP Thu Oct 5 21:02:42 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

Get-Date -UFormat %U does not match reference implementation
--------------------

### Repro

Get-Date -UFormat %U

Currently, `dateTime.DayOfYear / 7` is [being used](https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L514), but the code below is a better match. See [Date conversion specifiers](https://www.gnu.org/software/coreutils/manual/html_node/Date-conversion-specifiers.html) or [strftime](https://pubs.opengroup.org/onlinepubs/9699919799/functions/strftime.html).

```csharp
var startOfYear = new DateTime(dateTime.Year, 1, 1);
var offset = ((int)startOfYear.DayOfWeek + 6) % 7;
sb.Append(((offset+dateTime.DayOfYear-(int)dateTime.DayOfWeek)/7).ToString("00"));
```

### Expected

Based on running the `date -d $date +%U` as a reference implementation (see Environment for details).

PS> Get-Date 1999-01-01 -UFormat %U
00
PS> Get-Date 2000-02-14 -UFormat %U
07
PS> Get-Date 2001-03-29 -UFormat %U
12
PS> Get-Date 2002-05-12 -UFormat %U
19
PS> Get-Date 2003-06-25 -UFormat %U
25
PS> Get-Date 2004-08-07 -UFormat %U
31
PS> Get-Date 2005-09-20 -UFormat %U
38
PS> Get-Date 2006-11-03 -UFormat %U
44
PS> Get-Date 2007-12-17 -UFormat %U
50
PS> Get-Date 2009-01-29 -UFormat %U
04
PS> Get-Date 2010-03-14 -UFormat %U
11
PS> Get-Date 2011-04-27 -UFormat %U
17
PS> Get-Date 2012-06-09 -UFormat %U
23
PS> Get-Date 2013-07-23 -UFormat %U
29
PS> Get-Date 2014-09-05 -UFormat %U
35
PS> Get-Date 2015-10-19 -UFormat %U
42
PS> Get-Date 2016-12-01 -UFormat %U
48
PS> Get-Date 2018-01-14 -UFormat %U
02
PS> Get-Date 2019-02-27 -UFormat %U
08
PS> Get-Date 2020-04-11 -UFormat %U
14

### Actual

PS> Get-Date 1999-01-01 -UFormat %U
0
PS> Get-Date 2000-02-14 -UFormat %U
6
PS> Get-Date 2001-03-29 -UFormat %U
12
PS> Get-Date 2002-05-12 -UFormat %U
18
PS> Get-Date 2003-06-25 -UFormat %U
25
PS> Get-Date 2004-08-07 -UFormat %U
31
PS> Get-Date 2005-09-20 -UFormat %U
37
PS> Get-Date 2006-11-03 -UFormat %U
43
PS> Get-Date 2007-12-17 -UFormat %U
50
PS> Get-Date 2009-01-29 -UFormat %U
4
PS> Get-Date 2010-03-14 -UFormat %U
10
PS> Get-Date 2011-04-27 -UFormat %U
16
PS> Get-Date 2012-06-09 -UFormat %U
23
PS> Get-Date 2013-07-23 -UFormat %U
29
PS> Get-Date 2014-09-05 -UFormat %U
35
PS> Get-Date 2015-10-19 -UFormat %U
41
PS> Get-Date 2016-12-01 -UFormat %U
48
PS> Get-Date 2018-01-14 -UFormat %U
2
PS> Get-Date 2019-02-27 -UFormat %U
8
PS> Get-Date 2020-04-11 -UFormat %U
14

### Environment

Name                           Value
----                           -----
PSVersion                      7.4.0
PSEdition                      Core
GitCommitId                    7.4.0
OS                             Microsoft Windows 10.0.22621
Platform                       Win32NT
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0

WSL Ubuntu details:

$ uname -a
Linux localhost 5.15.133.1-microsoft-standard-WSL2 #1 SMP Thu Oct 5 21:02:42 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

Get-Date -UFormat %W does not match reference implementation
--------------------

### Repro

Get-Date -UFormat %W

Currently, `dateTime.DayOfYear / 7` is [being used](https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L527), but the code below is a better match. See [Date conversion specifiers](https://www.gnu.org/software/coreutils/manual/html_node/Date-conversion-specifiers.html) or [strftime](https://pubs.opengroup.org/onlinepubs/9699919799/functions/strftime.html).

```csharp
var startOfYearDayOfWeek = (int)(new DateTime(dateTime.Year, 1, 1)).DayOfWeek;
var adjustedDayOfYear = startOfYearDayOfWeek < 2 ? dateTime.DayOfYear + 7 : dateTime.DayOfYear;
var adjustedDayOfWeek = ((int)dateTime.DayOfWeek + 6) % 7;
sb.Append(((startOfYearDayOfWeek+adjustedDayOfYear-adjustedDayOfWeek)/7).ToString("00"));
```

### Expected

Based on running the `date -d $date +%W` as a reference implementation (see Environment for details).

PS> Get-Date 1999-01-01 -UFormat %W
00
PS> Get-Date 2000-02-14 -UFormat %W
07
PS> Get-Date 2001-03-29 -UFormat %W
13
PS> Get-Date 2002-05-12 -UFormat %W
18
PS> Get-Date 2003-06-25 -UFormat %W
25
PS> Get-Date 2004-08-07 -UFormat %W
31
PS> Get-Date 2005-09-20 -UFormat %W
38
PS> Get-Date 2006-11-03 -UFormat %W
44
PS> Get-Date 2007-12-17 -UFormat %W
51
PS> Get-Date 2009-01-29 -UFormat %W
04
PS> Get-Date 2010-03-14 -UFormat %W
10
PS> Get-Date 2011-04-27 -UFormat %W
17
PS> Get-Date 2012-06-09 -UFormat %W
23
PS> Get-Date 2013-07-23 -UFormat %W
29
PS> Get-Date 2014-09-05 -UFormat %W
35
PS> Get-Date 2015-10-19 -UFormat %W
42
PS> Get-Date 2016-12-01 -UFormat %W
48
PS> Get-Date 2018-01-14 -UFormat %W
02
PS> Get-Date 2019-02-27 -UFormat %W
08
PS> Get-Date 2020-04-11 -UFormat %W
14

### Actual

PS> Get-Date 1999-01-01 -UFormat %W
0
PS> Get-Date 2000-02-14 -UFormat %W
6
PS> Get-Date 2001-03-29 -UFormat %W
12
PS> Get-Date 2002-05-12 -UFormat %W
18
PS> Get-Date 2003-06-25 -UFormat %W
25
PS> Get-Date 2004-08-07 -UFormat %W
31
PS> Get-Date 2005-09-20 -UFormat %W
37
PS> Get-Date 2006-11-03 -UFormat %W
43
PS> Get-Date 2007-12-17 -UFormat %W
50
PS> Get-Date 2009-01-29 -UFormat %W
4
PS> Get-Date 2010-03-14 -UFormat %W
10
PS> Get-Date 2011-04-27 -UFormat %W
16
PS> Get-Date 2012-06-09 -UFormat %W
23
PS> Get-Date 2013-07-23 -UFormat %W
29
PS> Get-Date 2014-09-05 -UFormat %W
35
PS> Get-Date 2015-10-19 -UFormat %W
41
PS> Get-Date 2016-12-01 -UFormat %W
48
PS> Get-Date 2018-01-14 -UFormat %W
2
PS> Get-Date 2019-02-27 -UFormat %W
8
PS> Get-Date 2020-04-11 -UFormat %W
14

### Environment

Name                           Value
----                           -----
PSVersion                      7.4.0
PSEdition                      Core
GitCommitId                    7.4.0
OS                             Microsoft Windows 10.0.22621
Platform                       Win32NT
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0

WSL Ubuntu details:

$ uname -a
Linux localhost 5.15.133.1-microsoft-standard-WSL2 #1 SMP Thu Oct 5 21:02:42 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

Get-Date -UFormat %x does not match reference implementation
--------------------

### Repro

Get-Date -UFormat %x

Currently, `"{0:MM/dd/yy}"` is [being used](https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L539), but `"{0:MM\/dd\/yy}"` is a better match (though `"{0:d}"` is a reasonable match for the definition). See [Date conversion specifiers](https://www.gnu.org/software/coreutils/manual/html_node/Date-conversion-specifiers.html) or [strftime](https://pubs.opengroup.org/onlinepubs/9699919799/functions/strftime.html).

### Expected

Based on running the `date -d $date +%x` as a reference implementation (see Environment for details).

PS> Get-Date 1999-01-01 -UFormat %x
01/01/99
PS> Get-Date 2000-02-14 -UFormat %x
02/14/00
PS> Get-Date 2001-03-29 -UFormat %x
03/29/01
PS> Get-Date 2002-05-12 -UFormat %x
05/12/02
PS> Get-Date 2003-06-25 -UFormat %x
06/25/03
PS> Get-Date 2004-08-07 -UFormat %x
08/07/04
PS> Get-Date 2005-09-20 -UFormat %x
09/20/05
PS> Get-Date 2006-11-03 -UFormat %x
11/03/06
PS> Get-Date 2007-12-17 -UFormat %x
12/17/07
PS> Get-Date 2009-01-29 -UFormat %x
01/29/09
PS> Get-Date 2010-03-14 -UFormat %x
03/14/10
PS> Get-Date 2011-04-27 -UFormat %x
04/27/11
PS> Get-Date 2012-06-09 -UFormat %x
06/09/12
PS> Get-Date 2013-07-23 -UFormat %x
07/23/13
PS> Get-Date 2014-09-05 -UFormat %x
09/05/14
PS> Get-Date 2015-10-19 -UFormat %x
10/19/15
PS> Get-Date 2016-12-01 -UFormat %x
12/01/16
PS> Get-Date 2018-01-14 -UFormat %x
01/14/18
PS> Get-Date 2019-02-27 -UFormat %x
02/27/19
PS> Get-Date 2020-04-11 -UFormat %x
04/11/20

### Actual

PS> Get-Date 1999-01-01 -UFormat %x
01-01-99
PS> Get-Date 2000-02-14 -UFormat %x
02-14-00
PS> Get-Date 2001-03-29 -UFormat %x
03-29-01
PS> Get-Date 2002-05-12 -UFormat %x
05-12-02
PS> Get-Date 2003-06-25 -UFormat %x
06-25-03
PS> Get-Date 2004-08-07 -UFormat %x
08-07-04
PS> Get-Date 2005-09-20 -UFormat %x
09-20-05
PS> Get-Date 2006-11-03 -UFormat %x
11-03-06
PS> Get-Date 2007-12-17 -UFormat %x
12-17-07
PS> Get-Date 2009-01-29 -UFormat %x
01-29-09
PS> Get-Date 2010-03-14 -UFormat %x
03-14-10
PS> Get-Date 2011-04-27 -UFormat %x
04-27-11
PS> Get-Date 2012-06-09 -UFormat %x
06-09-12
PS> Get-Date 2013-07-23 -UFormat %x
07-23-13
PS> Get-Date 2014-09-05 -UFormat %x
09-05-14
PS> Get-Date 2015-10-19 -UFormat %x
10-19-15
PS> Get-Date 2016-12-01 -UFormat %x
12-01-16
PS> Get-Date 2018-01-14 -UFormat %x
01-14-18
PS> Get-Date 2019-02-27 -UFormat %x
02-27-19
PS> Get-Date 2020-04-11 -UFormat %x
04-11-20

### Environment

Name                           Value
----                           -----
PSVersion                      7.4.0
PSEdition                      Core
GitCommitId                    7.4.0
OS                             Microsoft Windows 10.0.22621
Platform                       Win32NT
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0

WSL Ubuntu details:

$ uname -a
Linux localhost 5.15.133.1-microsoft-standard-WSL2 #1 SMP Thu Oct 5 21:02:42 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
