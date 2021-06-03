/**
This script is for the final delivery table 
**/

drop table if exists freeze.deliver_tables
create table freeze.deliver_tables( 
    id int not null,
    loan_status bit,
    loan_amnt int, 
    term int,
    int_rate float,
    installment float, 
    sub_grade char(3),
    emp_length int, 
    home_ownership char(20), 
    IS_MORTGAGE bit,
    IS_RENT bit,
    IS_OWN bit,
    IS_ANY bit,
    IS_OTHER bit,
    verification_status char(20),
    is_verified bit,
    is_not_verified bit,
    is_source_verified bit,
    issue_d datetime, 
    issue_month varchar(8),
    purpose char(30),
    addr_state char(2), 
    dti float,
    fico_range_low int,
    fico_range_high int,
    open_acc int,
    pub_rec int,
    revol_bal int, 
    revol_util float,
    mort_acc int,
    pub_rec_backruptcies int,
    age int, 
    pay_status int
    constraint PK_delivery_ID primary key (id)
)

insert into freeze.deliver_tables
select 
     customers.id                      
    ,customers.loan_status             
    ,ltdeets.loan_amount as loan_amnt               
    ,ltdeets.term                    
    ,customers.int_rate                
    ,customers.installment             
    ,subgrade.subgrade as sub_grade               
    ,customers.emp_length              
    ,homeown.home_ownership          
    ,homeown.IS_MORTGAGE             
    ,homeown.IS_RENT                 
    ,homeown.IS_OWN                  
    ,homeown.IS_ANY                  
    ,homeown.IS_OTHER                
    ,vstat.verification_status     
    ,vstat.is_verified             
    ,vstat.is_not_verified         
    ,vstat.is_source_verified      
    ,issdates.issue_datetime as issue_d                 
    ,issdates.issue_month             
    ,purp.purpose                 
    ,stat.addr_state              
    ,customers.dti                     
    ,customers.fico_range_low          
    ,customers.fico_range_high         
    ,customers.open_acc                
    ,customers.pub_rec                 
    ,customers.revol_bal               
    ,customers.revol_util              
    ,customers.mort_acc                
    ,customers.pub_rec_backruptcies    
    ,customers.age                     
    ,customers.pay_status              
from inter.newoldcustomers customers 
left join inter.loan_term_details ltdeets 
on ltdeets.id = customers.id 
left join inter.subgrade subgrade
on customers.id = subgrade.id 
left join inter.home_ownership homeown 
on customers.id = homeown.id 
left join inter.verification_status vstat 
on customers.id = vstat.id 
left join inter.issue_dates issdates 
on customers.id = issdates.id 
left join inter.state stat  
on customers.id = stat.id
left join inter.purpose purp 
on purp.id = customers.id