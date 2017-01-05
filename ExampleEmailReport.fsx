(**
ExampleEmailReport.fsx
======================
Builds a chart and attaches it to an email, then sends it. 

Namespaces & References
-----------------------
Declare CLR library usage.
*)
open System
// Needed to send an email with the charts.
open System.Net.Mail
open System.Net.Mime
// Needed for FSharp.Charting's ShowChart() method.
#r "System.Windows.Forms.DataVisualization"

(**
Packages
--------
Download Paket if missing, then install NuGet packages using Paket, then reference and open package libraries.
*)
#I __SOURCE_DIRECTORY__
let ``paket.exe`` = IO.Path.Combine(__SOURCE_DIRECTORY__,"paket.exe")
if not (IO.File.Exists ``paket.exe``) then
    use wc = new Net.WebClient()
    wc.DownloadFile(wc.DownloadString("http://fsprojects.github.io/Paket/stable"),``paket.exe``)
let ``paket.dependencies`` = IO.Path.Combine(__SOURCE_DIRECTORY__,"paket.dependencies")
if not (IO.File.Exists ``paket.dependencies``) then
    IO.File.WriteAllLines(``paket.dependencies``,["source https://nuget.org/api/v2"])
#r "paket.exe"
open Paket
let dependencies = Dependencies.Locate(__SOURCE_DIRECTORY__)
dependencies.Add "FSharp.Data.SqlClient"
dependencies.Add "FSharp.Charting"
dependencies.Restore()

#I @"packages\FSharp.Data.SqlClient\lib\net40"
#r "FSharp.Data.SqlClient"
open FSharp.Data
#I @"packages\FSharp.Charting\lib\net40"
#r "FSharp.Charting"
open FSharp.Charting

(**
Database
--------
Install the AdventureWorks2014 database from 
https://msftdbprodsamples.codeplex.com/releases/view/125550 .
With VS installed, you should be able to unzip 
Adventure Works 2014 OLTP Script.zip into
C:\Program Files\Microsoft SQL Server\120\Tools\Samples\Adventure Works 2014 OLTP Script
(depending on version) then run something like
sqlcmd.exe -E -S "(localdb)\ProjectV12" -i instawdb.sql
(from that directory, running in a PowerShell or cmd prompt as admin).
*)
/// Use the SQL Server Type Provider to define a type-safe query for the top products (by $ amount)
/// summary order amount statistics by date.
[<Literal>]
let ConnStr = "server=(localdb)\ProjectsV13;database=AdventureWorks2014;integrated security=SSPI"
type OrderCmd = SqlCommandProvider<"
select p.Name, p.ProductID, o.OrderDate, sum(od.LineTotal) Total, 
       min(od.LineTotal) MinAmt, max(od.LineTotal) MaxAmt, 
       avg(od.LineTotal) AvgAmt, coalesce(stdev(od.LineTotal),0.0) StDevAmt, 
       (max(od.LineTotal) - min(od.LineTotal)) / 2 + min(od.LineTotal) MedianAmt
  from Production.Product p
  join Sales.SalesOrderDetail od
    on p.ProductID = od.ProductID
  join Sales.SalesOrderHeader o
    on od.SalesOrderID = o.SalesOrderID
 where p.ProductID in (select top 5 pod.ProductID from Sales.SalesOrderDetail pod 
       group by pod.ProductID order by sum(pod.LineTotal) desc)
   and o.OrderDate between '2014-03-01' and '2014-03-31'
 group by p.ProductID, p.Name, o.OrderDate
 order by p.ProductID, o.OrderDate
",ConnStr>
/// An instance of the query type.
let getOrders = new OrderCmd(ConnStr)

(**
Manipulate Data
---------------
*)
/// Converts a product name, record sequence tuple into a product name, sum total amount tuple.
let productTotal (n,p:OrderCmd.Record seq) = 
    n, Seq.sumBy (fun (d:OrderCmd.Record) -> d.Total.Value) p
/// Converts a record into a date, max amount tuple if it differs from the average amount.
let dateMax = 
    function 
    | (d:OrderCmd.Record) when d.MaxAmt.Value <> d.AvgAmt.Value 
        -> Some (d.OrderDate, d.MaxAmt.Value) 
    | _ -> None
/// Converts a record into a date, standard deviation of amount tuple if one exists.
let dateStDev = 
    function 
    | (d:OrderCmd.Record) when d.StDevAmt.Value <> 0.0 
        -> Some (d.OrderDate, float d.AvgAmt.Value + d.StDevAmt.Value) 
    | _ -> None
/// Converts a record into a date, average amount tuple.
let dateAvg (d:OrderCmd.Record) = d.OrderDate, d.AvgAmt.Value

/// Collects the records by product name, caching to prevent re-reading from a closed data reader.
let products = getOrders.Execute() |> Seq.cache |> Seq.groupBy (fun o -> o.Name)

/// Saves a chart to a temporary file, and returns a LinkedResource object for emailing.
let saveChart (c:ChartTypes.GenericChart) = 
    let file = IO.Path.ChangeExtension(IO.Path.GetTempFileName(),"png")
    // Needed to render to file. This is a workaround for bug #38
    // see https://github.com/fsharp/FSharp.Charting/issues/38
    // (This will display a window with the chart.)
    c.ShowChart() |> ignore
    c.SaveChartAs(file,ChartTypes.ChartImageFormat.Png)
    new LinkedResource(file,"image/png")

(**
Charts
------
For each product, build a compound chart, then append those to a list containing the 
summary pie chart, and save them all for emailing.
*)
/// The collection of charts, as LinkResource objects for emailing.
let charts =
    products 
        |> Seq.toList
        |> List.map 
            (fun (p,o) -> 
                Chart.Combine(charts=
                    [ Chart.Point(Title=p,Color=Drawing.Color.Red,
                        data=Seq.choose dateMax o)
                      Chart.Point(Color=Drawing.Color.DarkOrange,
                        data=Seq.choose dateStDev o)
                      Chart.Column(Color=Drawing.Color.Blue,
                        data=Seq.map dateAvg o) ]))
        |> List.append 
            [Chart.Pie(Title="Top 5 Products, March 2014",
                data=Seq.map productTotal products)]
        |> List.map saveChart

(**
Attach Chart to Email
---------------------
*)
/// Sends an email to the given address, with the given subject, using the LinkedResource 
/// objects as inline images in the body of the message.
let sendCharts (t:string) s c =
    /// The email message, initialized with the subject value.
    /// The default from address is set in machine.config's
    /// /configuration/system.net/mailSettings/smtp/@from
    let email = new MailMessage(Subject=s)
    email.To.Add(t)
    /// The HTML body of the email: inline images of the provided LinkedResource objects.
    let body = 
        List.map (fun (i:LinkedResource) -> 
                    sprintf "<div><img src='cid:%s' /></div>" i.ContentId) c 
            |> String.concat "\n"
    /// Create the body as an AlternateView object, to support inline images.
    use view = 
        AlternateView.CreateAlternateViewFromString(body, 
            ContentType MediaTypeNames.Text.Html)
    Seq.iter view.LinkedResources.Add c
    email.AlternateViews.Add(view)
    /// The SMTP sender, configured in the machine.config's
    /// /configuration/system.net/mailSettings element.
    use send = new SmtpClient()
    send.Send(email)

(**
Send Email
----------
*)
sendCharts "test@example.com" "Top Products Charts" charts