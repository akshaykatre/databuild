/**
Create a separate table with home ownership data. 
This table contains the ID as the primary key from both tables, the new and 
old customer. The boolean fields are also created in this table. 
**/

drop table if exists inter.home_ownership
create table inter.home_ownership (
    id int not null, 
    home_ownership char(20),
    IS_MORTGAGE bit,
    IS_RENT bit,
    IS_OWN bit,
    IS_ANY bit,
    IS_OTHER bit,
    constraint PK_hownership_ID primary key (id)

);

with CTE as (
select id, home_ownership
,case 
    when home_ownership = 'MORTGAGE' then 1 ELSE 0 END AS IS_MORTGAGE,
CASE 
    when home_ownership = 'RENT' then 1 ELSE 0 END AS IS_RENT,
CASE 
    when home_ownership = 'OWN' then 1 ELSE 0 END AS  IS_OWN,
CASE 
    when home_ownership = 'ANY' then 1 else 0 end as IS_ANY,
CASE 
    when home_ownership = 'OTHER' THEN 1 ELSE 0 END AS IS_OTHER
from [raw].api_oldcustomer

union
-- When joining with the new table in the future, let's keep in mind the 
-- ID should be joined with a negative value
select newc.id * -1 , hown.name as  home_ownership
, case 
    when hown.name = 'MORTGAGE' then 1 ELSE 0 END AS IS_MORTGAGE,
CASE 
    when hown.name = 'RENT' then 1 ELSE 0 END AS IS_RENT,
CASE 
    when hown.name = 'OWN' then 1 ELSE 0 END AS  IS_OWN,
CASE 
    when hown.name = 'ANY' then 1 else 0 end as IS_ANY,
CASE 
    when hown.name = 'OTHER' THEN 1 ELSE 0 END AS IS_OTHER
from [raw].api_newcustomer newc 
left join [raw].api_homeownership hown 
on newc.home_ownership_id = hown.id )  
insert into inter.home_ownership
select *
from CTE 