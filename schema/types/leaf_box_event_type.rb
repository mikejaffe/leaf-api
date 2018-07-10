module Schema
  Types::LeafBoxEventType = GraphQL::ObjectType.define do
    name "LeafBoxEventType"
    field :leaf_box_id, types.ID 
    field :grow_id, types.ID
    field :action, types.String
    field :value, types.String 
    field :created_at, Types::DateTimeType
    field :read, types.Boolean
  end
end