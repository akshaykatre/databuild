# Data delivery 

The following document is based on the delivery of data as requested in the following document: [Assignment Data Engineering]()








Current status 

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
