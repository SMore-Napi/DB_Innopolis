# Roman Soldatov BS19-02
# Warm up Exercise

import psycopg2
from faker import Faker
from random import randint

con = psycopg2.connect(database="postgres", user="postgres",
                       password="postgres", host="localhost", port="5432")

print("Database opened successfully")

cur = con.cursor()


def create_tables(table_names):
    for j, name in enumerate(table_names):
        cur.execute(f'''
         CREATE TABLE {name}
               (id INT PRIMARY KEY     NOT NULL,
               name           TEXT    NOT NULL,
               address            TEXT     NOT NULL,
               age INTEGER,
               review        TEXT);
               ''')
    print(f"Tables {table_names} created successfully")


def fill_tables(table_names, amount):
    print(f"Filling data in tables {table_names}...")
    fake = Faker()
    for i in range(amount):
        if i % (amount / 100) == 0:
            print(f"{i / amount * 100}/{100}%")
        user_id = str(i)
        user_name = fake.name()
        address = fake.address()
        age = str(randint(0, 100))
        review = fake.text()
        for j, name in enumerate(table_names):
            cur.execute(
                f"INSERT INTO {name} (id, name, address, age, review) "
                f"VALUES ('{user_id}', '{user_name}', '{address}', '{age}' , '{review}');")
            con.commit()
    print(f"Data filled in tables {table_names} successfully")


table_names = ['CUSTOMER_BTREE', 'CUSTOMER_HASH']
amount = 100000

create_tables(table_names)
fill_tables(table_names, amount)
