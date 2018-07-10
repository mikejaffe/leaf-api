module Schema
  Types::DelayedJobType = GraphQL::ObjectType.define do
    name "DelayedJobType"
    field :job_id, types.String
    field :item, types.String
  end
end