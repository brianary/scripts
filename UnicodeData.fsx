(**
Parse Unicode data
==================

Experiment with CSV type provider to read Unicode data.
*)
#r "nuget: FSharp.Data"
open System
open System.IO
open FSharp.Data
[<Literal>]
let pwd = __SOURCE_DIRECTORY__
type UnicodeData = CsvProvider<"./test/UnicodeData-sample.txt", ";", ResolutionFolder=pwd>
let u = UnicodeData.Load((Path.Combine(pwd, "./test/UnicodeData-sample.txt"))).Cache()
let first = u.Rows |> Seq.head
first
let asterisk = u.Rows |> Seq.find (fun x -> x.Name = "ASTERISK")
asterisk
