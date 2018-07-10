module Schema
  Types::EventLogType = GraphQL::ObjectType.define do
  name "EventLogType"
  field :id, types.Int
  field :leaf_box, Types::LeafBoxType
  field :grow, Types::GrowType
  field :action, types.String
  field :value, types.String
  field :created_at, Types::DateTimeType
  field :read, types.Boolean
end
end