/* Coenie Naude 01/16/2017: Remove Sage X3 Schema from Sage DB
* Go to Setup -> General Parameters -> Folders -> Select Folder and delete
* Go to the folder solution folder and delete, also delete the folder in X3 PUB 
* Make sure all the endpoint and folder has been removed from Sage
* Simply replace the schema name in the query and run against the Sage X3 DB*/

declare @schema varchar(200)
select @schema = 'SEED'

declare commands cursor for
select
'DROP ' + case
    when o.xtype = 'U' then 'TABLE'
    when o.xtype = 'V' then 'VIEW'
    when o.xtype = 'P' then 'PROCEDURE'
    when o.xtype = 'FN' then 'FUNCTION'
	when o.xtype = 'SO' then 'SEQUENCE'
    end + ' ' + s.name + '.' + o.name as SQL
from
    sys.sysobjects as o
    join sys.schemas as s on o.uid = s.schema_id
where
    s.name = @schema and
    o.xtype in ('U','V','P','FN','SO')
union all
select
'DROP SCHEMA ' + @schema

declare @cmd varchar(max)

open commands
fetch next from commands into @cmd
while @@FETCH_STATUS=0
begin
  exec(@cmd)
  fetch next from commands into @cmd
end

close commands
deallocate commands
