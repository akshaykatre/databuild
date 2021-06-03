/**
The following tables need to have their keys changed in order to align with the 
other tables and have a consistent naming convention. 

purpose: convert plurals to singular 
state: remove 'US_'

**/

drop table if exists inter.api_purpose
create table inter.api_purpose(
    id int not null,
    [name] varchar(30)
)

insert into inter.api_purpose
select 
    id
    , case when right([name], 1) = 'S' and [name] != 'SMALL_BUSINESS' then left([name], len([name])-1) else [name]
        end as [name]
from [raw].api_purpose  

drop table if exists inter.api_state
create table inter.api_state(
    id int not null,
    [name] varchar(30)
)

insert into inter.api_state
select 
    id-51 -- It seems in the table there is an offset by 51 :) 
    , right([name], 2) as [name]
from [raw].api_state  



--- Now with these new keys, lets construct their intermediate tables
drop table if exists inter.purpose 
drop index if exists PK_purpose_ID 
    on inter.purpose;

create table inter.purpose(
    id int not null,
    purpose varchar(30), 
    purpose_id int, 
    constraint PK_purpose_ID primary key (id) 
)

insert into inter.purpose
select * 
from (
    select oldc.id, purpose, purp.id as purpose_id 
    from [customer].[raw].[api_oldcustomer] oldc 
    left join [customer].[inter].[api_purpose] purp  
    on oldc.purpose = purp.name 
    
    union 

    select ncust.id * -1 as id, purp.name as purpose, purp.id  
    from [customer].[raw].[api_newcustomer] ncust 
    left join [customer].[inter].[api_purpose] purp 
    on ncust.purpose_id = purp.id 
    ) A 



    
--- Same for state 

drop table if exists inter.state
drop index if exists PK_state_ID 
    on inter.state;


create table inter.state(
    id int not null,
    addr_state varchar(30), 
    addr_state_id int, 
    constraint PK_state_ID primary key (id) 
)

insert into inter.state
select * 
from (
    select oldc.id, addr_state, stat.id as state_id 
    from [customer].[raw].[api_oldcustomer] oldc 
    left join [customer].[inter].[api_state] stat 
    on oldc.addr_state = stat.name 
    
    union 

    select ncust.id * -1 as id, stat.name as addr_state, stat.id  
    from [customer].[raw].[api_newcustomer] ncust 
    left join [customer].[inter].[api_state] stat 
    on ncust.addr_state_id = stat.id 
    ) A 