module Schema
  Types::DailyReportType = GraphQL::ObjectType.define do
    name "DailyReport" 
    field :avg_ph, types.Float
    field :avg_ec, types.Float
    field :avg_water_temp, types.Float
    field :avg_air_temp, types.Float
    field :avg_humidity, types.Float
    field :avg_light_level, types.Float
    field :avg_plant_height, types.Float
    field :photos, types[types.String]
    field :grow_day, types.Int
  end
end
