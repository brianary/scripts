if exists (select * from information_schema.columns where table_schema = 'HumanResources' and table_name = 'Department'
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert [HumanResources].[Department] on;

merge [HumanResources].[Department] as target
using ( values
(1, 'Engineering', 'Research and Development', '2008-04-30 00:00:00.00000'),
(2, 'Tool Design', 'Research and Development', '2008-04-30 00:00:00.00000'),
(3, 'Sales', 'Sales and Marketing', '2008-04-30 00:00:00.00000'),
(4, 'Marketing', 'Sales and Marketing', '2008-04-30 00:00:00.00000'),
(5, 'Purchasing', 'Inventory Management', '2008-04-30 00:00:00.00000'),
(6, 'Research and Development', 'Research and Development', '2008-04-30 00:00:00.00000'),
(7, 'Production', 'Manufacturing', '2008-04-30 00:00:00.00000'),
(8, 'Production Control', 'Manufacturing', '2008-04-30 00:00:00.00000'),
(9, 'Human Resources', 'Executive General and Administration', '2008-04-30 00:00:00.00000'),
(10, 'Finance', 'Executive General and Administration', '2008-04-30 00:00:00.00000'),
(11, 'Information Services', 'Executive General and Administration', '2008-04-30 00:00:00.00000'),
(12, 'Document Control', 'Quality Assurance', '2008-04-30 00:00:00.00000'),
(13, 'Quality Assurance', 'Quality Assurance', '2008-04-30 00:00:00.00000'),
(14, 'Facilities and Maintenance', 'Executive General and Administration', '2008-04-30 00:00:00.00000'),
(15, 'Shipping and Receiving', 'Inventory Management', '2008-04-30 00:00:00.00000'),
(16, 'Executive', 'Executive General and Administration', '2008-04-30 00:00:00.00000')
) as source ([DepartmentID], [Name], [GroupName], [ModifiedDate])
on source.[DepartmentID] = target.[DepartmentID]
when matched then
update set [Name] = source.[Name],
[GroupName] = source.[GroupName],
[ModifiedDate] = source.[ModifiedDate]
when not matched by target then
insert ([DepartmentID], [Name], [GroupName], [ModifiedDate])
values (source.[DepartmentID], source.[Name], source.[GroupName], source.[ModifiedDate])
when not matched by source then delete ;

if exists (select * from information_schema.columns where table_schema = 'HumanResources' and table_name = 'Department'
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert [HumanResources].[Department] off;
