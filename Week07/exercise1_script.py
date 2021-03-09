# Exercise 1

import psycopg2

con = psycopg2.connect(database="dvdrental", user="postgres",
                       password="postgres", host="localhost", port="5432")

cur = con.cursor()

cur.callproc('get_addresses', ())
print(cur.fetchall())

cur.close()
con.close()
