(**
Parse Unicode data
==================

Experiment with CSV type provider to read Unicode data.
*)
#r "nuget: FSharp.Data"
open System.IO
open FSharp.Data
[<Literal>]
let pwd = __SOURCE_DIRECTORY__
[<Literal>]
let headers = "Value,Name,Catgory,CombiningClass,BidirectionalCategory,DecompositionMapping,"
            + "DecimalDigitValue,DigitValue,NumericValue,Mirrored,OldName,Comment,Upper,Lower,Title"
type UnicodeData = CsvProvider<"./test/UnicodeData.txt", ";", ResolutionFolder=pwd, HasHeaders=false, Schema=headers>
let u = UnicodeData.Load((Path.Combine(pwd, "./test/UnicodeData.txt"))).Cache()
let first = u.Rows |> Seq.head
first
let asterisk = u.Rows |> Seq.find (fun x -> x.Name = "ASTERISK")
asterisk
