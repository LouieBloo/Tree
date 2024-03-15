class BirdsController < ApplicationController

    # GET /birds?nodes[]=2&nodes[]=3
    # Given an array of node names (or ids), return all birds the target nodes have and any birds
    # the target nodes descendants have
    def index
        begin
            all_birds = []
            params[:nodes].each do |node|
                target_node = Node.find_by(name: node)
                # we can do validation here in case their is no node found, skipping for now
                found_birds = target_node.all_birds_from_descendants

                if found_birds.present?
                    all_birds.concat(found_birds)
                end
            end
            # no specs for how we should return, just return the json representation of the birds in an array
            render json: all_birds.flatten.uniq
        rescue => e
            # General error handling
            render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
        end
    end
    
end
