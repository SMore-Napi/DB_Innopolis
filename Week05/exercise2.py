# Roman Soldatov BS19-02
# Exercise 2

import psycopg2

con = psycopg2.connect(database="postgres", user="postgres",
                       password="postgres", host="localhost", port="5432")

cur = con.cursor()


def analyze_review(name):
    cur.execute(
        f"Explain ANALYZE SELECT * FROM {name} "
        f"WHERE to_tsvector('english', review) @@ to_tsquery('english', 'face | group | movie');")
    print(cur.fetchall())
    con.commit()


def create_gin_index(name):
    cur.execute(f"CREATE INDEX gin_index ON {name} USING gin (to_tsvector('english', review));")
    con.commit()


def create_gist_index(name):
    cur.execute(f"CREATE INDEX gist_index ON {name} USING gist (to_tsvector('english', review));")
    con.commit()


table_names = ['CUSTOMER_BTREE', 'CUSTOMER_HASH']

print("Before indexing")
# Analyze one of the created table because they are both the same
analyze_review(table_names[0])

# Create indexes
create_gin_index(table_names[0])
create_gist_index(table_names[1])

# Analyze the same query but using indexes
print("After indexing with gin")
analyze_review(table_names[0])
print("After indexing with gist")
analyze_review(table_names[1])
