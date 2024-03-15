class CommonAncestorsController < ApplicationController

    # GET /common_ancestors?a=XXX&b=YYY
    # Given 2 node ids, return the information about the least common ancestor and its path
    def index
        node_a = Node.find_by(name: params[:a])
        node_b = Node.find_by(name: params[:b])
      
        # Check if either node wasn't found
        if node_a.nil? || node_b.nil?
            render json: { error: "One or both nodes not found." }, status: :not_found
            return
        end
      
        begin
            lowest_common_ancestor_path = Node.lowest_common_ancestor_path(node_a, node_b)
      
            if lowest_common_ancestor_path.present?
                render json: {
                    root_id: lowest_common_ancestor_path.last.name,
                    lowest_common_ancestor: lowest_common_ancestor_path.first.name,
                    depth: lowest_common_ancestor_path.count
                }
            else
                # No ancestor found, return nulls
                render json: {
                    root_id: nil,
                    lowest_common_ancestor: nil,
                    depth: nil
                }, status: :not_found
            end
        rescue => e
            # General error handling
            render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
        end
    end
end