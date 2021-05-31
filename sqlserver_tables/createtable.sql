--CREATE TABLE sqlite_sequence([name] ,seq);
DROP TABLE IF EXISTS [raw].api_oldcustomer;
CREATE TABLE  [raw].api_oldcustomer (id integer NOT NULL PRIMARY KEY , loan_status_2 varchar(16) NULL, loan_status integer NULL, 
                    loan_amnt real NULL, term integer NULL, int_rate real NULL, installment real NULL, sub_grade varchar(2) NULL, 
                    emp_length integer NULL, home_ownership varchar(16) NULL, annual_inc varchar(32) NULL, verification_status varchar(16) NULL, 
                    issue_d varchar(32) NULL, purpose varchar(32) NULL, addr_state varchar(2) NULL, dti real NULL, fico_range_low integer NULL, 
                    fico_range_high integer NULL, open_acc integer NULL, pub_rec integer NULL, revol_bal integer NULL, revol_util real NULL, 
                    mort_acc integer NULL, pub_rec_bankruptcies integer NULL, age integer NULL, pay_status integer NULL);

DROP TABLE IF EXISTS [raw].api_homeownership;
CREATE TABLE  [raw].api_homeownership (id integer NOT NULL PRIMARY KEY , [name] varchar(16) NULL);

DROP TABLE IF EXISTS [raw].api_purpose;
CREATE TABLE  [raw].api_purpose (id integer NOT NULL PRIMARY KEY , [name] varchar(32) NULL);

DROP TABLE IF EXISTS [raw].api_state;
CREATE TABLE  [raw].api_state (id integer NOT NULL PRIMARY KEY , [name] varchar(8) NULL);

DROP TABLE IF EXISTS [raw].api_subgrade;
CREATE TABLE  [raw].api_subgrade (id integer NOT NULL PRIMARY KEY , [name] varchar(2) NULL);

DROP table if exists [raw].api_verificationstatus;
CREATE TABLE  [raw].api_verificationstatus (id integer NOT NULL PRIMARY KEY , [name] varchar(16) NULL);

drop table if exists [raw].api_newcustomer;
CREATE TABLE  [raw].api_newcustomer (id integer NOT NULL PRIMARY KEY , loan_status integer NULL, loan_amnt varchar(16) NULL, term varchar(8) NULL, 
int_rate real NULL, installment real NULL, sub_grade_id integer NULL, employment_length integer NULL, home_ownership_id integer NULL, 
annual_inc integer NULL, verification_status_id integer NULL, issued varchar(32) NULL, purpose_id integer NULL, addr_state_id integer NULL, 
dti real NULL, fico_range_low real NULL, fico_range_high real NULL, open_acc real NULL, pub_rec real NULL, revol_bal real NULL, revol_util real NULL, 
mort_acc real NULL, pub_rec_bankruptcies real NULL, age real NULL, payment_status real NULL);
