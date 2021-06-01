drop table if exists inter.newoldcustomers
create table inter.newoldcustomers( 
    id int not null,
    loan_status bit,
    int_rate float,
    installment float, 
    emp_length int, 
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
    constraint PK_newoldcust_ID primary key (id)
)

insert into inter.newoldcustomers
select * 
from (
    SELECT 
    id 
    ,loan_status     
    ,int_rate        
    ,installment     
    ,emp_length      
    ,dti             
    ,fico_range_low  
    ,fico_range_high 
    ,open_acc        
    ,pub_rec         
    ,revol_bal       
    ,revol_util      
    ,mort_acc             
    ,pub_rec_bankruptcies 
    ,age                   
    ,pay_status           
    from [raw].api_oldcustomer

    union

    SELECT 
    id * -1 as id
    ,loan_status     
    ,int_rate        
    ,installment     
    ,employment_length     as emp_length  
    ,dti             
    ,fico_range_low  
    ,fico_range_high 
    ,open_acc        
    ,pub_rec         
    ,revol_bal       
    ,revol_util      
    ,mort_acc             
    ,pub_rec_bankruptcies 
    ,age                   
    ,payment_status      as pay_status      
    from [raw].api_newcustomer
) A 