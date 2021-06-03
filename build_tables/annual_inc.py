import pymssql
import pandas 
import json 
import statistics

f = open("../dbconfig.json")
config = json.load(f)
conn = pymssql.connect(server="localhost", database="customer", user=config['username'], password=config['password'])  

## Import the old customer dataset as a dataframe
df_oldcust = pandas.read_sql_query("SELECT id, annual_inc from [raw].[api_oldcustomer]", conn)

## Fun one-liner in python to split, convert and average the income! 
df_oldcust['annual_inc'] = df_oldcust["annual_inc"].apply(lambda x: round(statistics.mean([float(y.replace("(","").replace("]", "")) for y in x.split(",")])))

## Import the new customer dataset as a dataframe
df_newcust = pandas.read_sql_query("SELECT id*-1 as id, annual_inc from [raw].[api_newcustomer]", conn)

df_custs = pandas.concat([df_oldcust, df_newcust])

cursor = conn.cursor()

cursor.execute('''
DROP TABLE IF EXISTS [inter].annual_inc
CREATE TABLE [inter].annual_inc (
    id int not null, 
    annual_inc int,
    constraint PK_annualinc_ID primary key (id)
)
''')

for index, rows in df_custs.iterrows():
    cursor.execute('insert into [inter].annual_inc values %r' %(tuple(rows.values) ,))
conn.commit()

conn.close()