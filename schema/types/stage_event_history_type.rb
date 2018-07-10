module Schema
  Types::StageEventHistoryType = GraphQL::ObjectType.define do
    name "StageEventHistoryType"

    field :stage, types.String
    field :date, Types::DateTimeType   
    field :stage_index, types.Int   
  end
  
end
