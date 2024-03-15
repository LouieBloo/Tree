class Node
    include ActiveGraph::Node
  
    property :name, type: String
  
    has_one :out, :parent, type: :PARENT_OF, model_class: 'Node'
    has_many :in, :children, origin: :parent, model_class: 'Node'

    has_many :out, :birds, type: :BIRD_LINK, model_class: 'Bird'

    # Given 2 nodes get the path to the root that they both share. 
    def self.lowest_common_ancestor_path(node_a, node_b)
        # this query does 2 things, first it gets the least common ancestor between 2 points,
        # then finds all ancestors of the common ancestor (basically just all_ancestors)
        result = ActiveGraph::Base.query("
            MATCH (node1:Node {name: $name1}), (node2:Node {name: $name2}),
                path1 = (node1)-[:PARENT_OF*0..]->(lca:Node)<-[:PARENT_OF*0..]-(node2)
            WITH lca
            MATCH (lca)-[:PARENT_OF*0..]->(descendant)
            RETURN DISTINCT descendant", 
            name1: node_a.name, name2: node_b.name)

        # parse the results into something more friendly to consume
        result.present? ? result.map(&:values).flatten : nil
    end

    # return all birds from this node and any descendants
    def all_birds_from_descendants
        result = ActiveGraph::Base.query("
            MATCH (parent:Node {name: $name})<-[:PARENT_OF*0..]-(child:Node)-[:BIRD_LINK]->(bird:Bird)
            RETURN DISTINCT bird",
            name: self.name)

        # parse the results into something more friendly to consume
        result.present? ? result.map(&:values).flatten : nil
    end

    # get all my ancestor nodes
    def all_ancestors
        @descendants ||= self.query_as(:child).match("(child)-[:PARENT_OF*1..]->(n)").return("n").proxy_as(Node, :n)
    end
end