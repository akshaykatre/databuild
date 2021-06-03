import pandas
import json 
import pymssql
from pysqldq import dqchecks 

cfile = open("dbconfig.json")
login = json.load(cfile)

conn = pymssql.connect(server=login['server'], database="customer", user=login['username'], password=login['password'])

columns = pandas.read_sql_query('select column_name, table_name, table_schema from information_schema.columns', conn)

allchecks = [] 

for index, rows in columns.iterrows():
    print("running check for.. : ", rows['column_name'])
    connectionmap = {'schema': rows['table_schema'], 'table': rows['table_name']}
    comp_query = dqchecks.getCompleteness(connectionMap=connectionmap, attribute=rows['column_name'])

    check = pandas.read_sql_query(comp_query, conn)
    check['schema'] = rows['table_schema']
    check['table'] = rows['table_name']
    check['attribute'] = rows['column_name']

    allchecks.append(check)

df = pandas.concat(allchecks)