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


The motivation to build the database on MS SQL Server is to be able to test and reuse existing python libraries for data quality and data lineage purposes. (See below for more details)

--- 
### 2. Initial analysis on the data


Based on the [Assignment Data Engineering](https://github.com/akshaykatre/databuild/blob/c4fdabc97f122c4243d4bb9fbed586790449a172/Assignment%20data%20engineering%20description%20pdf%20format.pdf) the final dataset is a combination of user data from two underlying tables. An initial analysis is performed on the attributes from the source tables *api_newcustomer* and *api_oldcustomer* tables. The following table summaries the differences and changes required to align the data from the two sources.

--- 

Table below: 


| column               | delivery data type | Required fixes                                                                                                                |
|----------------------|--------------------|-------------------------------------------------------------------------------------------------------------------------------|
| loan_status          | boolean            | Convert the column to bit                                                                                                     |
| loan_amnt            | int                | - convert the x.0k into thousands                                                                                             |
|                      |                    | - change the format to integer to match the required output                                                                   |
| term                 | int                | - convert the x.0Y into months                                                                                                |
|                      |                    | - change the format to integer to match the required output                                                                   |
| int_rate             | double?            | This seems like a consistent field across the two sources.                                                                    |
| installment          | double?            | This seems like a consistent field across the two sources.                                                                    |
| sub_grade            | char               | - In the newcustomer table, there is an ID to the sub_grade;                                                                  |
|                      |                    | - Delivery requires we give the grade itself. So need to convert this ID into the actual value                                |
| emp_length           | int                | - Comes from two differently named attributes in the two tables                                                               |
|                      |                    | - Align into a single attribute with data type integer                                                                        |
|                      |                    | - DQ checks on source? Completeness?                                                                                          |
| home_ownership      | char                | Available from two different source fields in the two tables                                                                   |
| is_mortgage          | boolean?           | missing                                                                                                                       |
| is_rent              | boolean?           | missing                                                                                                                       |
| is_own               | boolean?           | missing                                                                                                                       |
| is_any               | boolean?           | missing                                                                                                                       |
| is_other             | boolean?           | missing                                                                                                                       |
| annual_inc           | int                |  - How is the income from oldcustomer a range and not a number?                                                               |
|                      |                    |    - What should be the choice? -- pick the average in this case                                                                                               |
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
| purpose              | char               | - The IDs have a small mis-match, is that an issue? how should it be resolved?                                                |
|                      |                    | - The tables need alignment since from the newcustomer it is again the ID that is mentioned and char itself                   |
| addr_state           | char               | - The IDs have a small mis-match, is that an issue? how should it be resolved?                                                |
|                      |                    | - The tables need alignment since from the newcustomer it is again the ID that is mentioned and char itself                   |
| dti                  |                    | This seems like a consistent field across the two sources.                                                                    |
| fico_range_low       |                    | This seems like a consistent field across the two sources.                                                                    |
| fico_range_high      |                    | This seems like a consistent field across the two sources.                                                                    |
| open_acc             |                    | This seems like a consistent field across the two sources.                                                                    |
| pub_rec              |                    | This seems like a consistent field across the two sources.                                                                    |
| revol_bal            |                    | This seems like a consistent field across the two sources.                                                                    |
| revol_util           |                    | This seems like a consistent field across the two sources.                                                                    |
| mort_acc             |                    | This seems like a consistent field across the two sources.                                                                    |
| pub_rec_backruptcies |                    | This seems like a consistent field across the two sources.                                                                    |
| age                  |                    | This seems like a consistent field across the two sources.                                                                    |
| pay_status           |                    | Old customer table has max value only till 8? is that expected?                                                               |



ID is not distinct between the customer tables, but these are indeed distinct customers. Therefore, it should be sufficient to have separate IDs from the two tables. 
