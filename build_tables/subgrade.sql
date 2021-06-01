/**
This need a simple consolidation into one table based on the subgroup_ID from new customer
**/ 

drop table if exists inter.subgrade
drop index if exists PK_subgrade_ID 
    on inter.subgrade;

create table inter.subgrade(
    id int not null,
    subgrade varchar(30), 
    subgrade_id int, 
    constraint PK_subgrade_ID primary key (id) 
)

insert into inter.subgrade
select * 
from (
    select oldc.id, sub_grade, sub.id as subgrade_id 
    from [customer].[raw].[api_oldcustomer] oldc 
    left join [customer].[raw].[api_subgrade] sub 
    on oldc.sub_grade = sub.name 
    
    union 

    select ncust.id * -1 as id, sub.name as sub_grade, sub.id  
    from [customer].[raw].[api_newcustomer] ncust 
    left join [customer].[raw].[api_subgrade] sub 
    on ncust.sub_grade_id = sub.id 
    ) A 