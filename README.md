# README

This rails project exposes 2 endpoints that query against the Node and Bird models. The models are saved in Neo4j for performance and graph querying simplicity:
https://neo4j.com/news/how-much-faster-is-a-graph-database-really/

# GET /common_ancestors?a=XXX&b=YYY
Given 2 node ids, return the information about the least common ancestor and its path

## Example request and response
/common_ancestor?a=5497637&b=2820230 should return 
{root_id: 130, lowest_common_ancestor: 125, depth: 2} 

/common_ancestor?a=5497637&b=130 should return 
{root_id: 130, lowest_common_ancestor: 130, depth: 1} 

/common_ancestor?a=5497637&b=4430546 should return 
{root_id: 130, lowest_common_ancestor: 4430546, depth: 3} 

if there is no common node match, return null for all fields
/common_ancestor?a=9&b=4430546 should return 
{root_id: null, lowest_common_ancestor: null, depth: null} 

if a==b, it should return itself 
/common_ancestor?a=4430546&b=4430546 should return 
{root_id: 130, lowest_common_ancestor: 4430546, depth: 3} 

# GET /birds?nodes[]=2&nodes[]=3
Given an array of node names (or ids), return all birds the target nodes have and any birds the target nodes descendants have

## Example request and response
/birds?nodes[]=2&nodes[]=3
[
    {
        "bird": {
            "name": "b2",
            "id": "1e76e884-4e52-4c7e-84a8-8bf47a0ba89f"
        }
    },
    {
        "bird": {
            "name": "b3",
            "id": "8436506e-b2ae-4fc2-bfbb-99a291a17f11"
        }
    }
]