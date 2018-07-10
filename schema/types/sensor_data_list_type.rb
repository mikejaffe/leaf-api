module Schema
  Types::SensorDataListType = GraphQL::ObjectType.define do
    name "SensorDataList"

    field :time, Types::DateTimeType
    field :value, types.Float
  end
end
