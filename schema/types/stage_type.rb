module Schema
  Types::StageType = GraphQL::ObjectType.define do
    name "Stage"

    field :name, types.String 
    field :symbol, types.String
    field :duration, types.Float
    field :index, types.Int 
    # field :id, types.ID
    # field :type, types.String do 
    #   resolve -> (obj, args, ctx) {
    #     obj.type
    #   }
    # end
    # field :order, types.Int 
    # field :description, types.String
    # field :stage_durations, !types[Types::StageDurationType]
  end
end
