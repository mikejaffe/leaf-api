module Schema
  Queries::GrowsQuery = GraphQL::ObjectType.define do
    
    field :grow, Types::GrowType  do
      description "An instance of a grow."
      argument :id, !types.ID 
      resolve ->(obj, args, ctx) {
        Grow.find(args[:id])
      }
    end
    
    field :grows, !types[Types::GrowType] do
      description "A list of current user grows."
      resolve ->(obj, args, ctx) {
        ctx[:current_user].grows.includes(:recipe).order(started_at: :desc)
      }
    end  
  end

  
end

