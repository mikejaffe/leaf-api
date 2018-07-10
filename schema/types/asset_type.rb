module Schema
  Types::AssetType = GraphQL::ObjectType.define do
    name "Asset"

    field :id, types.ID
    field :file, types.String
    
  end
end
