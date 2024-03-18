if exists (select * from information_schema.columns where table_schema = 'Person' and table_name = 'PhoneNumberType'
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert [Person].[PhoneNumberType] on;

merge [Person].[PhoneNumberType] as target
using ( values
(1, 'Cell', '2017-12-13 13:19:22.27300'),
(2, 'Home', '2017-12-13 13:19:22.27300'),
(3, 'Work', '2017-12-13 13:19:22.27300')
) as source ([PhoneNumberTypeID], [Name], [ModifiedDate])
on source.[PhoneNumberTypeID] = target.[PhoneNumberTypeID]
when matched then
update set [Name] = source.[Name],
[ModifiedDate] = source.[ModifiedDate]
when not matched by target then
insert ([PhoneNumberTypeID], [Name], [ModifiedDate])
values (source.[PhoneNumberTypeID], source.[Name], source.[ModifiedDate])
when not matched by source then delete ;

if exists (select * from information_schema.columns where table_schema = 'Person' and table_name = 'PhoneNumberType'
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert [Person].[PhoneNumberType] off;
