# Data delivery 

The following document is based on the delivery of data as requested in the following document: [Assignment Data Engineering](https://github.com/akshaykatre/databuild/blob/c4fdabc97f122c4243d4bb9fbed586790449a172/Assignment%20data%20engineering%20description%20pdf%20format.pdf)

## Plan of action 

During the data delivery process, the following steps were followed: 

1. Converted SQLite database into an SQL Server database  
2. Performed an initial analysis into the data
3. Build the data tables and uploaded the scripts on GIT 
4. Build a data quality check to check for completeness of the data
5. Build a dashboard for the data quality check and deploy it on the web

The next few paragraphs documents in details the above five steps. 

### 1. Conversion of database from SQLite to SQL Server 


The motivation to build the database on MS SQL Server is to be able to test and reuse existing python libraries for data quality and data lineage purposes. (See below for more details). The following are the steps followed to convert the tables from SQLite to SQL Server: 

To perform a dump of the data from SQLite to SQL Server, is done by literally creating the SQL scripts required and then running the SQL scripts on the database. 

Open the sqlite database with: ``` sqlite3 <nameofdb>.sqlite3```
```
.output alloutput.sql 
.dump 
```

You may have to perform some small corrections to the SQL script, but essentially the script is then all you need. 

With ```sqlcmd``` you can now create your tables/ databases as described in the script
```
sqlcmd -S localhost -i alloutput.sql
```

The scripts used in converting these tables can be found: [sqlserver_tables](https://github.com/akshaykatre/databuild/tree/master/sqlserver_tables)


--- 
### 2. Initial analysis on the data


Based on the [Assignment Data Engineering](https://github.com/akshaykatre/databuild/blob/c4fdabc97f122c4243d4bb9fbed586790449a172/Assignment%20data%20engineering%20description%20pdf%20format.pdf) the final dataset is a combination of user data from two underlying tables. An initial analysis is performed on the attributes from the source tables *api_newcustomer* and *api_oldcustomer* tables. The following table summarises the differences and changes required to align the data from the two sources.

--- 

Table below: 


| column               | delivery data type | Required fixes                                                                                                                |
|----------------------|--------------------|-------------------------------------------------------------------------------------------------------------------------------|
| loan_status          | boolean            | Convert the column to bit                                                                                                     |
| loan_amnt            | int                | - convert the x.0k into thousands                                                                                             |
|                      |                    | - change the format to integer to match the required output                                                                   |
| term                 | int                | - convert the x.0Y into months                                                                                                |
|                      |                    | - change the format to integer to match the required output                                                                   |
| int_rate             | double?            | This is a consistent field across the two sources.                                                                    |
| installment          | double?            | This is a consistent field across the two sources.                                                                    |
| sub_grade            | char               | - In the newcustomer table, there is an ID to the sub_grade;                                                                  |
|                      |                    | - Delivery requires we give the grade itself. So need to convert this ID into the actual value                                |
| emp_length           | int                | - Comes from two differently named attributes in the two tables                                                               |
|                      |                    | - Align into a single attribute with data type integer                                                                        |
|                      |                    | - Perform DQ checks on source, observe some missing values                                                                                          |
| home_ownership      | char                | Available from two different source fields in the two tables                                                                   |
| is_mortgage          | boolean?           | missing                                                                                                                       |
| is_rent              | boolean?           | missing                                                                                                                       |
| is_own               | boolean?           | missing                                                                                                                       |
| is_any               | boolean?           | missing                                                                                                                       |
| is_other             | boolean?           | missing                                                                                                                       |
| annual_inc           | int                |  - How is the income from oldcustomer a range and not a number?                                                               |
|                      |                    |    - What should be the choice?                                                                                               |
|                      |                    |    - Interestingly, it has only 12 distinct values for these ranges!                                                          |
|                      |                    | - Align data type  to integer                                                                                                 |
| verification_status  | char               |  - Deliver this as a field with a character data type                                                                         |
|                      |                    |  - therefore convert the newcustomer attribute from integer to character                                                      |
| is_verified          | boolean?           | missing                                                                                                                       |
| is_not_verified      | boolean?           | missing                                                                                                                       |
| is_source_verified   | booleans?          | missing                                                                                                                       |
| issue_d              | date               | - Called "issued" in newcustomer table                                                                                        |
|                      |                    | - Align formatting to date format                                                                                             |
|                      |                    | - Request says it wants the month, so what is the format in which this data is expected to be delivered? YYYYMM  |
| purpose              | char               | - The IDs have a small mis-match, is that an issue? how should it be resolved?  
|                      |                    | - The tables need alignment since from the newcustomer it is again the ID that is mentioned and char itself                   |
| addr_state           | char               | - The IDs have a small mis-match, is that an issue? how should it be resolved?     |
|                      |                    | - The tables need alignment since from the newcustomer it is again the ID that is mentioned and char itself                   |
| dti                  |                    | This is a consistent field across the two sources.                                                                    |
| fico_range_low       |                    | This is a consistent field across the two sources.                                                                    |
| fico_range_high      |                    | This is a consistent field across the two sources.                                                                    |
| open_acc             |                    | This is a consistent field across the two sources.                                                                    |
| pub_rec              |                    | This is a consistent field across the two sources.                                                                    |
| revol_bal            |                    | This is a consistent field across the two sources.                                                                    |
| revol_util           |                    | This is a consistent field across the two sources.                                                                    |
| mort_acc             |                    | This is a consistent field across the two sources.                                                                    |
| pub_rec_backruptcies |                    | This is a consistent field across the two sources.                                                                    |
| age                  |                    | This is a consistent field across the two sources.                                                                    |
| pay_status           |                    | Old customer table has max value only till 8? is that expected?                                                               |


--- 

---

### 3. Building data tables and assumptions 

#### ID 
ID is not distinct between the customer tables, but these are indeed distinct customers. To keep the IDs different in the final table, the customers from the *api_newcustomer* table have been assigned a negative value. 

#### Loan Amount
This attribute is delivered as an integer and has a base of 1000. The string 'k' has been converted to '000s to be in line with the data in the table *api_oldcustomer*.

#### Term
This attribute is delivered as an integer and has been delivered as number of months, consistent with the table *api_oldcustomer*.

The above two changes can be found in: [loan_amnt.sql](https://github.com/akshaykatre/databuild/blob/0fb3b6351c5065871d1b3f6104b366758f5613d4/build_tables/loan_amnt.sql)


#### Annual Inc
The annual income is delivered as an integer. The data from the *api_oldcustomer* table was provided as a *list* stating the range of the annual income instead of a number. In these cases we have used the average value between the two. This can be found in the file: [annual_inc.py](https://github.com/akshaykatre/databuild/blob/0fb3b6351c5065871d1b3f6104b366758f5613d4/build_tables/annual_inc.py)

#### Purpose 
The values of keys between the *api_newcustomer* and *api_oldcustomer* were misaligned by singular and plural words, the choice was made to convert all values to singular. 

#### Addr_state 
The key of this attribute was offset by 51 in the *api_addr_state* table causing a misalignment between the two source tables when combined. Therefore, the key value was subtracted by 51 when building the final set. 

The above two changes can be found in the file: [keychanges.sql](https://github.com/akshaykatre/databuild/blob/0fb3b6351c5065871d1b3f6104b366758f5613d4/build_tables/keychanges.sql)


### 4. Build a data quality check 
An existing library [pysqldq](https://pypi.org/project/pysqldq/) was used to run an out of the box completeness check that detects NULLs, empty strings and fields filled "NA". The output of the DQ can be visualised as a dataframe that can be converted into your preferred output format choice. 