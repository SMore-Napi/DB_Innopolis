# Exercise 1
import psycopg2
#import ssl
#import certifi
#import geopy
from geopy.geocoders import Nominatim

#ctx = ssl.create_default_context(cafile=certifi.where())
#geopy.geocoders.options.default_ssl_context = ctx

con = psycopg2.connect(database="dvdrental", user="postgres",
                       password="postgres", host="localhost", port="5432")
cur = con.cursor()

sql1 = """
ALTER TABLE address
ADD longitude DOUBLE PRECISION;
"""

sql2 = """
ALTER TABLE address
ADD latitude DOUBLE PRECISION;
"""

cur.callproc('get_addresses', ())
arr = cur.fetchall()

cur.execute(sql1)
con.commit()
cur.execute(sql2)
con.commit()

geolocator = Nominatim(user_agent="ex1")
for line in arr:
    id = line[0]
    add = line[1]
    location = geolocator.geocode(add)
    if location is None:
        lat, long = 0, 0
    else:
        lat, long = location.latitude, location.longitude
    cur.execute(f"""
    UPDATE address SET latitude = {lat}, longitude = {long}
    WHERE address_id = {id};
    """)
    con.commit()
cur.close()
con.close()
