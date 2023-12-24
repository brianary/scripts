<#
.SYNOPSIS
Tests PowerShell's Get-Date -UFormat formatting matched against the outputs from the GNU date command.

.NOTES
To generate dateformats.tsv in linux:

echo -e 'date\tA\ta_\tB\tb_\tC\tc_\tD\td_\te\tF\tG\tg_\th\tj\tm\tq\tU\tu_\tV\tW\tw_\tx\tY\ty_' > dateformats.tsv
for ((i = 0; i <= 9999; i++)); do
    date -d "1999-01-01 +$i days" '+%Y-%m-%d%t%A%t%a%t%B%t%b%t%C%t%c%t%D%t%d%t"%e"%t%F%t%G%t%g%t%h%t%j%t%m%t%q%t%U%t%u%t%V%t%W%t%w%t%x%t%Y%t%y' >> dateformats.tsv
done

.LINK
https://www.gnu.org/software/coreutils/manual/html_node/Date-conversion-specifiers.html

.LINK
https://github.com/PowerShell/PowerShell/blob/master/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs
#>

$formatdata = Import-Csv -Path (Join-Path $PSScriptRoot 'dateformats.tsv') -Delimiter "`t" #|select -f 10 #|? date -eq 2001-01-01
Describe 'Get-Date' -Tag Get-Date {
    Context 'UFormat matches GNU date output' -Tag 'Get-Date:UFormat' {
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:A_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%A';Expected=$_.A}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:a_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%a';Expected=$_.a_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:B_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%B';Expected=$_.B}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:b_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%b';Expected=$_.b_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:C_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%C';Expected=$_.C}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:c_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%c';Expected=$_.c_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:D_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%D';Expected=$_.D}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:d_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%d';Expected=$_.d_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:e' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%e';Expected=$_.e}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:F' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%F';Expected=$_.F}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:G_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%G';Expected=$_.G}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:g_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%g';Expected=$_.g_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:h' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%h';Expected=$_.h}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:j' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%j';Expected=$_.j}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:m' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%m';Expected=$_.m}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:q' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%q';Expected=$_.q}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:U_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%U';Expected=$_.U}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:u_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%u';Expected=$_.u_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:V' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%V';Expected=$_.V}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:W_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%W';Expected=$_.W}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:w_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%w';Expected=$_.w_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:x' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%x';Expected=$_.x}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:Y_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%Y';Expected=$_.Y}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'UFormat:y_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%y';Expected=$_.y_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            Get-Date $Date -UFormat $Format |Should -BeExactly $Expected
        }
    }
    Context 'New algorithm to match GNU date output' -Tag 'Get-Date:NewAlgorithm' {
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'NewAlgorithm:c_Lower' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%c';Expected=$_.c_}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            # https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L421
            # currently using: "{0:ddd} {0:dd} {0:MMM} {0:yyyy} {0:HH}:{0:mm}:{0:ss}"
            # Replaced by the locale's appropriate date and time representation.
            "{0:ddd} {0:MMM} {0,2:%d} {0:HH}:{0:mm}:{0:ss} {0:yyyy}" -f (Get-Date $Date) |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'NewAlgorithm:D_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%D';Expected=$_.D}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            # https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L425
            # currently using: "{0:MM/dd/yy}"
            # Equivalent to %m / %d / %y.
            "{0:MM\/dd\/yy}" -f (Get-Date $Date) |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'NewAlgorithm:q' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%q';Expected=$_.q}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            # not currently implemented
            1+[int]::DivRem($Date.Month-1, 3).Item1 |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'NewAlgorithm:U_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%U';Expected=$_.U}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            # https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L514
            # currently using: dateTime.DayOfYear / 7
            # The first Sunday of January is the first day of week 1; days in the new year before this are in week 0.
            $soyoffset = ((Get-Date -Year $Date.Year -Month 1 -Day 1).DayOfWeek+6)%7
            '{0:00}' -f [int]::DivRem($soyoffset+$Date.DayOfYear-$Date.DayOfWeek, 7).Item1 |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'NewAlgorithm:W_Upper' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%W';Expected=$_.W}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            # https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L527
            # currently using: dateTime.DayOfYear / 7
            # The first Monday of January is the first day of week 1; days in the new year before this are in week 0.
            $SOYDOW = [int](Get-Date -Year $Date.Year -Month 1 -Day 1).DayOfWeek
            $DOY = $SOYDOW -lt 2 ? ($Date.DayOfYear+7) : ($Date.DayOfYear)
            $DOW = ($Date.DayOfWeek+6)%7
            $SOW = $SOYDOW+$DOY-$DOW
            '{0:00}' -f [int]::DivRem($SOW, 7).Item1 |Should -BeExactly $Expected
        }
        It "Formats date '<Date>' using '<Format>' as '<Expected>'" `
            -Tag 'NewAlgorithm:x' -TestCases ($formatdata.ForEach({@{Date=$_.date;Format='%x';Expected=$_.x}})) {
            Param([datetime] $Date, [string] $Format, [string] $Expected)
            # https://github.com/PowerShell/PowerShell/blob/release/v7.4.1/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetDateCommand.cs#L539
            # currently using: "{0:MM/dd/yy}"
            # Replaced by the locale's appropriate date representation.
            # should probably be: "{0:d}"
            "{0:MM\/dd\/yy}" -f (Get-Date $Date) |Should -BeExactly $Expected
        }
    }
}
