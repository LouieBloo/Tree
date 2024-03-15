class Bird
    include ActiveGraph::Node
  
    property :name, type: String
  
    has_one :in, :node, origin: :birds, model_class: 'Node'

end