(**
US Federal Holiday Detection
============================

Here's how to determine whether a date is a US federal holiday using F#.
You probably want to curry the first two boolean parameters with the appropriate settings
(some departments observe Sunday holidays on Monday, and some observe Saturday holidays on Friday).
*)
open System  

let getHoliday sunToMon satToFri (date:DateTime) =  
   match date.Month, date.Day, (date.Day-1)/7+1, date.DayOfWeek with
   | 1, 1, _, _ -> "New Year's Day"  
   | 1, 2, _, DayOfWeek.Monday when sunToMon -> "New Year's Day (observed)"  
   | 1, _, 3, DayOfWeek.Monday -> "Martin Luther King, Jr. Day"  
   | 2, _, 3, DayOfWeek.Monday -> "Presidents Day"  
   | 5, d, _, DayOfWeek.Monday when d >= 25 -> "Memorial Day" // active pattern matching!
   | 7, 3, _, DayOfWeek.Friday when satToFri -> "Independence Day (observed)"  
   | 7, 4, _, _ -> "Independence Day"  
   | 7, 5, _, DayOfWeek.Monday when sunToMon -> "Independence Day (observed)"  
   | 9, _, 1, DayOfWeek.Monday -> "Labor Day"  
   | 10, _, 2, DayOfWeek.Monday -> "Columbus Day"  
   | 11, 10, _, DayOfWeek.Friday when satToFri -> "Veterans Day (observed)"  
   | 11, 11, _, _ -> "Veterans Day"  
   | 11, 12, _, DayOfWeek.Monday when sunToMon -> "Veterans Day (observed)"  
   | 11, _, 4, DayOfWeek.Thursday -> "Thanksgiving Day"  
   | 12, 24, _, DayOfWeek.Friday when satToFri -> "Christmas Day (observed)"  
   | 12, 25, _, _ -> "Christmas Day"  
   | 12, 26, _, DayOfWeek.Monday when sunToMon -> "Christmas Day (observed)"  
   | 12, 31, _, DayOfWeek.Friday when satToFri -> "New Year's Day (observed)"  
   | _ -> null
