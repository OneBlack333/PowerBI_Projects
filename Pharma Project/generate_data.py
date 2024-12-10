import random
import numpy as np
import pandas as pd
import mysql.connector
from mysql.connector import Error
import datetime as dt


con = None
try:
    con = mysql.connector.connect(user="root", password="M@nchi8582", host="localhost", database="aceso")
    if con.is_connected():
        print("Database connection was successful.")
except Error as e:
    print(e)

curs = con.cursor()

curs.execute("SELECT store_id FROM store")
store_ids = curs.fetchall()

curs.execute("SELECT customer_id FROM customer")
customer_ids = curs.fetchall()

curs.execute("SELECT drug_id FROM drug")
drug_ids = curs.fetchall()

bill_table = pd.DataFrame(columns=["bill_id", "drug_id", "customer_id", "store_id", "quantity", "bill_date"])

bill_id = np.random.randint(10000000, 99999999, size=8169)
quantity, items = 0, 0


def generate_date():
    year = random.randint(2017, 2022)
    month = random.randint(1, 12)
    if month == 2:
        day = random.randint(1, 28)
    else:
        day = random.randint(1, 30)
    date_obj = dt.date(year, month, day)
    date = date_obj.strftime("%Y-%m-%d")
    return date


index = 1
for id in bill_id:
    items = random.randint(1, 10)
    store_id = random.choice(store_ids)[0]
    customer_id = random.choice(customer_ids)[0]
    bill_date = generate_date()
    for i in range(items):
        drug_id = random.choice(drug_ids)[0]
        quantity = random.randint(1, 5)
        bill_table.loc[index] = [id, drug_id, customer_id, store_id, quantity, bill_date]
        index += 1

print(len(bill_table))
bill_table.drop_duplicates(subset=["bill_id", "drug_id"], keep=False, inplace=True)
print(len(bill_table))

bill_table.to_csv("C:/Users/manis/OneDrive/Documents/College Work/DBMS Project/bill.csv", index=False)
con.close()
