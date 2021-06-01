/**
The format of the issued column in the newcustomer table is all over the place. 

1> select len(issued), max(issued) from [raw].api_newcustomer group by len(issued)
2> go

----------- --------------------------------
          9 12-Jan-18
          7 2018-01
         10 2018-01-12
         19 2018-01-12 00:00:00

Therefore, this first needs to be made into a single format, and then combined with 
the data in the oldcustomer table. 

**/ 

drop table if exists inter.issue_dates 
create table inter.issue_dates(
    id int not null, 
    issue_datetime datetime,
    issue_month varchar(8),
    constraint PK_issuedates_ID primary key (id)
);


with CTE as (
select 
    id, 
    issue_d as issue_datetime
from [customer].[raw].api_oldcustomer

union

select 
    id * - 1 as id, 
    case when len(issued) = 19 or len(issued) = 10 or len(issued) = 9 then convert(datetime, issued) 
         when len(issued) = 7 then convert(datetime, issued+'-01')  -- need this for standarisation
    end as issue_datetime

from [customer].[raw].api_newcustomer
)
insert into inter.issue_dates
select * ,  
        LEFT(CONVERT(varchar, issue_datetime,112),6) as issue_month
    from CTE 


--where len(issued) = 19 or len(issued) = 10 or len(issued) = 7