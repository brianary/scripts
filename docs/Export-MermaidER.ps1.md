---
external help file: -help.xml
Module Name:
online version: https://learn.microsoft.com/dotnet/api/microsoft.sqlserver.management.smo.table
schema: 2.0.0
---

# Export-MermaidER.ps1

## SYNOPSIS
Generates a Mermaid entity relation diagram for database tables.

## SYNTAX

```
Export-MermaidER.ps1 [-Table] <Table> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-DbaDbTable -SqlInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016 -Table Production.Product |Export-MermaidER.ps1
```

erDiagram
Product {
	int ProductID PK "identity(1,1); Primary key for Product records."
	Name Name "Name of the product."
	nvarchar ProductNumber "Unique product identification number."
	Flag MakeFlag "0 = Product is purchased, 1 = Product is manufactured in-house."
	Flag FinishedGoodsFlag "0 = Product is not a salable item.
1 = Product is salable."
	nvarchar Color "nullable; Product color."
	smallint SafetyStockLevel "Minimum inventory quantity.
"
	smallint ReorderPoint "Inventory level that triggers a purchase order or work order.
"
	money StandardCost "Standard cost of the product."
	money ListPrice "Selling price."
	nvarchar Size "nullable; Product size."
	nchar SizeUnitMeasureCode FK "nullable; Unit of measure for Size column."
	nchar WeightUnitMeasureCode FK "nullable; Unit of measure for Weight column."
	decimal Weight "nullable; Product weight."
	int DaysToManufacture "Number of days required to manufacture the product."
	nchar ProductLine "nullable; R = Road, M = Mountain, T = Touring, S = Standard"
	nchar Class "nullable; H = High, M = Medium, L = Low"
	nchar Style "nullable; W = Womens, M = Mens, U = Universal"
	int ProductSubcategoryID FK "nullable; Product is a member of this product subcategory.
Foreign key to ProductSubCategory.ProductSubCategoryID.
"
	int ProductModelID FK "nullable; Product is a member of this product model.
Foreign key to ProductModel.ProductModelID."
	datetime SellStartDate "Date the product was available for sale."
	datetime SellEndDate "nullable; Date the product was no longer available for sale."
	datetime DiscontinuedDate "nullable; Date the product was discontinued."
	uniqueidentifier rowguid "ROWGUIDCOL number uniquely identifying the record.
Used to support a merge replication sample."
	datetime ModifiedDate "Date and time the record was last updated."
}

### EXAMPLE 2
```
Get-DbaDbTable -SqlInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016 -Schema Purchasing |Export-MermaidER.ps1
```

erDiagram
ProductVendor {
	int ProductID PK "Primary key.
Foreign key to Product.ProductID."
	int BusinessEntityID PK "Primary key.
Foreign key to Vendor.BusinessEntityID."
	int AverageLeadTime "The average span of time (in days) between placing an order with the vendor and receiving the purchased product."
	money StandardPrice "The vendor's usual selling price."
	money LastReceiptCost "nullable; The selling price when last purchased."
	datetime LastReceiptDate "nullable; Date the product was last received by the vendor."
	int MinOrderQty "The maximum quantity that should be ordered."
	int MaxOrderQty "The minimum quantity that should be ordered."
	int OnOrderQty "nullable; The quantity currently on order."
	nchar UnitMeasureCode FK "The product's unit of measure."
	datetime ModifiedDate "Date and time the record was last updated."
}
PurchaseOrderDetail {
	int PurchaseOrderID PK "Primary key.
Foreign key to PurchaseOrderHeader.PurchaseOrderID."
	int PurchaseOrderDetailID PK "identity(1,1); Primary key.
One line number per purchased product."
	datetime DueDate "Date the product is expected to be received."
	smallint OrderQty "Quantity ordered."
	int ProductID FK "Product identification number.
Foreign key to Product.ProductID."
	money UnitPrice "Vendor's selling price of a single product."
	money LineTotal "Per product subtotal.
Computed as OrderQty * UnitPrice."
	decimal ReceivedQty "Quantity actually received from the vendor."
	decimal RejectedQty "Quantity rejected during inspection."
	decimal StockedQty "Quantity accepted into inventory.
Computed as ReceivedQty - RejectedQty."
	datetime ModifiedDate "Date and time the record was last updated."
}
PurchaseOrderHeader {
	int PurchaseOrderID PK "identity(1,1); Primary key."
	tinyint RevisionNumber "Incremental number to track changes to the purchase order over time."
	tinyint Status "Order current status.
1 = Pending; 2 = Approved; 3 = Rejected; 4 = Complete"
	int EmployeeID FK "Employee who created the purchase order.
Foreign key to Employee.BusinessEntityID."
	int VendorID FK "Vendor with whom the purchase order is placed.
Foreign key to Vendor.BusinessEntityID."
	int ShipMethodID FK "Shipping method.
Foreign key to ShipMethod.ShipMethodID."
	datetime OrderDate "Purchase order creation date."
	datetime ShipDate "nullable; Estimated shipment date from the vendor."
	money SubTotal "Purchase order subtotal.
Computed as SUM(PurchaseOrderDetail.LineTotal)for the appropriate PurchaseOrderID."
	money TaxAmt "Tax amount."
	money Freight "Shipping cost."
	money TotalDue "Total due to vendor.
Computed as Subtotal + TaxAmt + Freight."
	datetime ModifiedDate "Date and time the record was last updated."
}
ShipMethod {
	int ShipMethodID PK "identity(1,1); Primary key for ShipMethod records."
	Name Name "Shipping company name."
	money ShipBase "Minimum shipping charge."
	money ShipRate "Shipping charge per pound."
	uniqueidentifier rowguid "ROWGUIDCOL number uniquely identifying the record.
Used to support a merge replication sample."
	datetime ModifiedDate "Date and time the record was last updated."
}
Vendor {
	int BusinessEntityID PK "Primary key for Vendor records. 
Foreign key to BusinessEntity.BusinessEntityID"
	AccountNumber AccountNumber "Vendor account (identification) number."
	Name Name "Company name."
	tinyint CreditRating "1 = Superior, 2 = Excellent, 3 = Above average, 4 = Average, 5 = Below average"
	Flag PreferredVendorStatus "0 = Do not use if another vendor is available.
1 = Preferred over other vendors supplying the same product."
	Flag ActiveFlag "0 = Vendor no longer used.
1 = Vendor is actively used."
	nvarchar PurchasingWebServiceURL "nullable; Vendor URL."
	datetime ModifiedDate "Date and time the record was last updated."
}
ProductVendor }|--|| Vendor : "BusinessEntityID: Foreign key constraint referencing Vendor.BusinessEntityID."
PurchaseOrderDetail }|--|| PurchaseOrderHeader : "PurchaseOrderID: Foreign key constraint referencing PurchaseOrderHeader.PurchaseOrderID."
PurchaseOrderHeader }|--|| ShipMethod : "ShipMethodID: Foreign key constraint referencing ShipMethod.ShipMethodID."
PurchaseOrderHeader }|--|| Vendor : "VendorID: Foreign key constraint referencing Vendor.VendorID."

## PARAMETERS

### -Table
An SMO table object associated to the database to examine.

```yaml
Type: Table
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES
All tables in the pipeline must exist in the same database.

## RELATED LINKS

[https://learn.microsoft.com/dotnet/api/microsoft.sqlserver.management.smo.table](https://learn.microsoft.com/dotnet/api/microsoft.sqlserver.management.smo.table)

[https://dbatools.io/](https://dbatools.io/)

