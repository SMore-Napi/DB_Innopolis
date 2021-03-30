## Week 9.

### Find all the documents in the collection restaurants.
Command:
```
{}
```
Export query with filters:
```
db.restaurants.find({})
```
[Output result](ex1.json)

### Find the fields restaurant_id, name, borough and cuisine for all the documents in the collection restaurant.
Filter Command:
```
{}
```
Project Command:
```
{restaurant_id:1, name:1, borough:1, cuisine:1}
```
Export query with filters:
```
db.restaurants.find(
  undefined,
  {restaurant_id: 1,name: 1,borough: 1,cuisine: 1}
)
```
[Output result](ex2.json)

### Find the first 5 restaurant which is in the borough Bronx.
Filter Command:
```
{}
```
Limit Command:
```
5
```
Export query with filters:
```
db.restaurants.find(
  undefined
).limit(5)
```
[Output result](ex3.json)

### Find the restaurant Id, name, borough and cuisine for those restaurants which prepared dish except 'American' and 'Chinese' or restaurant's name begins with letter 'Wil’.
Filter Command:
```
{$or: [{cuisine : {$nin : ["American ", "Chinese"]}}, {name: /Wil*/}]}
```
Project Command:
```
{restaurant_id:1, name:1, borough:1, cuisine:1}
```
Export query with filters:
```
db.restaurants.find(
  {$or: [{ cuisine: { $nin: [ 'American ', 'Chinese' ] }},{ name: RegExp('Wil*')}]},
  {restaurant_id: 1,name: 1,borough: 1,cuisine: 1}
)
```
[Output result](ex4.json)