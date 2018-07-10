module Schema
  Types::UserType = GraphQL::ObjectType.define do
    name "User"

    field :id, types.ID
    field :email, types.String
    field :first_name, types.String
    field :last_name, types.String
    field :token, types.String
    field :phone, types.String
    field :particle_token, types.String
    field :leaf_boxes, types[Types::LeafBoxType] 
    field :preferences, types.String do 
      resolve -> (obj, args, ctx) {
        obj.preferences.to_json
      }
    end
    field :leaf_orders, !types[Types::LeafOrderType]
  end
end
