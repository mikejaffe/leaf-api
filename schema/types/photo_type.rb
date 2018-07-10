module Schema
  Types::PhotoType = GraphQL::ObjectType.define do
    name "Photo"

    field :file, types.String
    field :created_at, Types::DateTimeType
    
  end
end
