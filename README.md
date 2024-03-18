# README

This rails project exposes 2 endpoints that query against the Node and Bird models. The models are saved in Neo4j for performance and graph querying simplicity:
https://neo4j.com/news/how-much-faster-is-a-graph-database-really/

Nodes have a name property and 2 relationships with other nodes. They have 1 parent and many child nodes.

Nodes also have many birds while birds only belong to 1 node. 

# Creating nodes
n1 = Node.create(name: "1")
n2 = Node.create(name: "2")
n3 = Node.create(name: "3")
n4 = Node.create(name: "4")
n5 = Node.create(name: "5")

## Linking parents
n2.parent = n1
n3.parent = n1
n4.parent = n2
n5.parent = n2

## Linking birds
b1 = Bird.create(name: "b1")
b11 = Bird.create(name: "b11")

n1.birds = [b1, b11]

# Endpoints
## GET /common_ancestors?a=XXX&b=YYY
Given 2 node ids, return the information about the least common ancestor and its path

## Example request and response
/common_ancestor?a=5497637&b=2820230  

`{root_id: 130, lowest_common_ancestor: 125, depth: 2} `

/common_ancestor?a=5497637&b=130  

`{root_id: 130, lowest_common_ancestor: 130, depth: 1} `

/common_ancestor?a=5497637&b=4430546  

`{root_id: 130, lowest_common_ancestor: 4430546, depth: 3} `

if there is no common node match, return null for all fields

/common_ancestor?a=9&b=4430546 

`{root_id: null, lowest_common_ancestor: null, depth: null} `

if a==b, it should return itself 

/common_ancestor?a=4430546&b=4430546  

`{root_id: 130, lowest_common_ancestor: 4430546, depth: 3} `

## GET /birds?nodes[]=2&nodes[]=3
Given an array of node names (or ids), return all birds the target nodes have and any birds the target nodes descendants have

### Example request and response
/birds?nodes[]=2&nodes[]=3

`[
    {
        "id": "1e76e884-4e52-4c7e-84a8-8bf47a0ba89f",
        "name": "b2"
    },
    {
        "id": "8436506e-b2ae-4fc2-bfbb-99a291a17f11",
        "name": "b22"
    },
    {
        "id": "8633bcd6-ad90-46bf-be1b-ae141d82f7fb",
        "name": "b4"
    },
    {
        "id": "898e0b05-339c-471d-91ae-5a310eb202f3",
        "name": "b44"
    },
    {
        "id": "448f4274-a041-4ebd-87fb-e570bcc293c8",
        "name": "b5"
    },
    {
        "id": "5165cd70-ae1f-4514-ae5c-3283b3334bc5",
        "name": "b55"
    }
]`
