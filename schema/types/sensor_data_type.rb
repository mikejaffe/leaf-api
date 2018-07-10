module Schema
  Types::SensorDataType = GraphQL::ObjectType.define do
    name "SensorData"

    field :time_unit, types.String
    field :sensor, types.String 
    field :values, !types[Types::SensorDataListType]
  end
end
