if exists (select * from information_schema.columns where table_schema = 'Production' and table_name = 'ProductModelIllustration'
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert [Production].[ProductModelIllustration] on;

merge [Production].[ProductModelIllustration] as target
using ( values
(7, 3, '2014-01-09 14:41:02.16700'),
(10, 3, '2014-01-09 14:41:02.16700'),
(47, 4, '2014-01-09 14:41:02.18300'),
(47, 5, '2014-01-09 14:41:02.18300'),
(48, 4, '2014-01-09 14:41:02.18300'),
(48, 5, '2014-01-09 14:41:02.18300'),
(67, 6, '2014-01-09 14:41:02.20000')
) as source ([ProductModelID], [IllustrationID], [ModifiedDate])
on source.[ProductModelID] = target.[ProductModelID]
and source.[IllustrationID] = target.[IllustrationID]
when matched then
update set [ModifiedDate] = source.[ModifiedDate]
when not matched by target then
insert ([ProductModelID], [IllustrationID], [ModifiedDate])
values (source.[ProductModelID], source.[IllustrationID], source.[ModifiedDate])
when not matched by source then delete ;

if exists (select * from information_schema.columns where table_schema = 'Production' and table_name = 'ProductModelIllustration'
and columnproperty(object_id(table_name), column_name,'IsIdentity') = 1)
set identity_insert [Production].[ProductModelIllustration] off;
