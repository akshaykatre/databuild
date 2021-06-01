/**
In the new customer table, the format of the column loan_amount is 
in varchar with a 'k' at the end to indicate thousand.

We will just remove it, convert it to a thousand and construct a new 
loan_amount table. 

We will also add to this table, Term, which has a similar treatment, 
but to convert Y to months. 

**/

drop table if exists inter.loan_term_details
create table inter.loan_term_details(
    id int not null,
    loan_amount int, 
    term int,
    constraint PK_loanamnt_ID primary key (id)
);


with CTE as (
SELECT 
    id 
    ,convert(float, left(loan_amnt, len(loan_amnt)-1))* 1000 as loan_amount 
    ,convert(float, left(term, len(term)-1))*12 as term
from 
    [customer].[raw].api_newcustomer

union

SELECT 
    id * - 1 as id, 
    loan_amnt as loan_amount,
    term
from [customer].[raw].[api_oldcustomer]
)
insert into inter.loan_term_details
select id, convert(int, loan_amount), convert(int, term) 
from cte 
