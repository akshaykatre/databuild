/**
Create a separate table with verification statuses.  
This table contains the ID as the primary key from both tables, the new and 
old customer. The boolean fields are also created in this table. 
**/

drop table if exists inter.verification_status
create table inter.verification_status (
    id int not null, 
    verification_status char(20),
    is_verified bit,
    is_not_verified bit,
    is_source_verified bit,
    constraint PK_vstatus_ID primary key (id)
);

with CTE as (
select id
    ,verification_status 
    ,
    case when verification_status = 'Source Verified' then 1 ELSE 0 END AS is_source_verified,
    CASE when verification_status = 'Verified' then 1 ELSE 0 END AS is_verified,
    CASE when verification_status = 'Not Verified' then 1 ELSE 0 END AS  is_not_verified
    from [raw].api_oldcustomer

union
-- When joining with the new table in the future, let's keep in mind the 
-- ID should be joined with a negative value
select newc.id * -1 
    , verf.name as  verification_status
    , 
    CASE when verf.name = 'Source Verified' then 1 ELSE 0 END AS is_source_verified,
    CASE when verf.name = 'Verified' then 1 ELSE 0 END AS is_verified,
    CASE when verf.name = 'Not Verified' then 1 ELSE 0 END AS  is_not_verified
from [raw].api_newcustomer newc 
left join [raw].api_verificationstatus verf 
on newc.verification_status_id = verf.id )  
insert into inter.verification_status
select *
from CTE 