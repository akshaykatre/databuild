import pandas
import json 
import pymssql

cfile = open("dbconfig.json")
login = json.load(cfile)

## Create a map of all the expected output fields, with their datatypes
map_output = { 
    "loan_status" : "boolean",
    "loan_amnt" : "integer",
    "term": "integer",
    "int_rate": "double", 
    "installment": "double", 
    "sub_grade": "char", 
    "emp_length": "integer",
    "home_owners_hip": "char", 
    "is_mortgage": "boolean", 
    "is_rent": "boolean", 
    "is_own": "boolean", 
    "is_any": "boolean", 
    "is_other": "boolean", 
    "annual_inc": "integer", 
    "verification_status": "char", 
    "is_verified": "boolean", 
    "is_not_verified": "boolean", 
    "is_source_verified": "boolean", 
    "issue_d": "date", 
    "purpose": "char", 
    "addr_state": "char", 
    "dti": "double", 
    "fico_range_high": "integer", 
    "open_acc": "integer", 
    "pub_rec": "integer", 
    "revol_bal": "integer", 
    "revol_util": "double", 
    "mort_acc": "integer", 
    "pub_rec_bankruptcies": "integer", 
    "age": "integer", 
    "pay_status": "integer"
}

out_df = pandas.DataFrame(map_output.items(), columns = ['colname', 'datatype'])

conn = pymssql.connect(server="localhost", database="customer", user=login['username'], password=login['password'])

## Loop through the fields for the expected output, to get an indication of which fields are 
## existing with the same name in the two tables, and which ones do not 

for rows in out_df.iterrows():
    colname, datatype = rows[1]['colname'], rows[1]['datatype']
    print("For column: ", colname, " having datatype: ", datatype)
    df =  pandas.read_sql_query("SELECT column_name, data_type, table_name from information_schema.columns where column_name='{0}'".format(colname), conn)
    if not df.empty:
        #continue
        print(df)
    else: 
       # continue
        print("Dataframe is empty")
    print("*"*20)



'''
The following fields are missing from the final deliverable:
 - is_mortgage
 - is_rent
 - is_own
 - is_any
 - is_other
 - is_verified
 - is_not_verified
 - is_source_verified: how is this different from is_verified? Is this the same as verification_status_id? 

 For the others, let's look at a SQL notebook to verify if everything in order 
'''