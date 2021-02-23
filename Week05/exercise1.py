# Roman Soldatov BS19-02
# Exercise 1

import psycopg2

con = psycopg2.connect(database="postgres", user="postgres",
                       password="postgres", host="localhost", port="5432")

cur = con.cursor()


def analyze_age(name):
    cur.execute(f"Explain ANALYZE SELECT * FROM {name} WHERE age > 32 AND age < 36;")
    print(cur.fetchall())
    con.commit()


def create_btree_index(name):
    cur.execute(f"CREATE INDEX btree_index ON {name} USING btree (age);")
    con.commit()


def create_hash_index(name):
    cur.execute(f"CREATE INDEX hash_index ON {name} USING hash (age);")
    con.commit()


table_names = ['CUSTOMER_BTREE', 'CUSTOMER_HASH']

print("Before indexing")
# Analyze one of the created table because they are both the same
analyze_age(table_names[0])

# Create indexes
create_btree_index(table_names[0])
create_hash_index(table_names[1])

# Analyze the same query but using indexes
print("After indexing with B-tree")
analyze_age(table_names[0])
print("After indexing with Hash")
analyze_age(table_names[1])
