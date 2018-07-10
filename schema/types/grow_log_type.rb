module Schema
    Types::GrowLogType = GraphQL::ObjectType.define do
    name "GrowLogType"
    #guard ->(obj, args, ctx) { ctx[:current_user].present? }

    field :id, types.ID
    field :leaf_box_id , types.Int
    field :grow_id, types.Int
    field    :ph, types.Float 
    field    :ec, types.Float
    field    :water_temp, types.Float
    field    :air_temp, types.Float
    field    :humidity, types.Float
    field  :light_state, types.Boolean
    field    :light_level, types.Float 
    field    :plant_height, types.Float
    field :leaf_time, types.String do 
      resolve ->(obj, args, ctx) {
        obj.leaf_time.to_s
      }
    end
  end
end
