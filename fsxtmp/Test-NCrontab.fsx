(**
NCrontab Schedule Test
======================

Returns a sampling of the next several date & times scheduled by an NCrontab string.

Usage
-----

### Interactive

```cmd
dotnet fsi .\Test-NCrontab.fsx
```

### Single test, with optional example count

```cmd
dotnet fsi .\Test-NCrontab.fsx "0 20 29 2 Mon" 42
```
*)
#r "nuget: NCrontab"
open System
let testNCrontab n s =
    let cron = NCrontab.CrontabSchedule.Parse(s)
    let times = Seq.unfold (fun d -> match cron.GetNextOccurrence(d) with | x -> Some(x,x)) DateTime.Now
    Seq.take n times |> Seq.iter (printfn "%O")
let readNCrontab () =
    printf "ncrontab> "
    match Console.ReadLine () with
    | "quit" | "q" -> false
    | s ->
        testNCrontab 20 s
        true
if fsi.CommandLineArgs.Length < 2 then
    while readNCrontab () do ()
else
    let n = match Int32.TryParse(Array.tryItem 2 fsi.CommandLineArgs |> Option.defaultValue "") with | false,_ -> 20 | true,n -> n
    Array.get fsi.CommandLineArgs 1 |> testNCrontab n
