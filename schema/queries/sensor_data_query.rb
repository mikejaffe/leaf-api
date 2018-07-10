module Schema
  Queries::SensorDataQuery = GraphQL::ObjectType.define do
    
    field :sensor_data, Types::SensorDataType  do
      description "Get sensor data for a leaf_box."
      argument :leaf_box_id, !types.ID 
      argument :date, !types.String
      argument :sensor, !types.String
      argument :time_unit, !types.String
      #guard ->(obj, args, ctx) { ctx[:current_user].present? } 
      resolve ->(obj, args, ctx) {

        leaf_box = LeafBox.find(args[:leaf_box_id]) 
        Time.zone = leaf_box.time_zone
        time_from = Time.zone.parse(args[:date]) 
         
        range = if args[:time_unit] == "hour"
            time_from..time_from 
          elsif args[:time_unit] == "day"
            (time_from - 7.days)..time_from
          elsif args[:time_unit] == "all" 
             leaf_box.current_grow.started_at..time_from
        end
        
        

        results = GrowLog.stats({
          grow_id: leaf_box.current_grow.id,
          val: [args[:sensor]],
          range_from: range.min.strftime("%Y-%m-%d"),
          range_to: range.max.strftime("%Y-%m-%d")
          })

        #sensor_data_result = leaf_box.sensor_data({query_date: DateTime.parse(args[:date]), sensor: args[:sensor], time_unit: args[:time_unit]  })
        if results[:grow_logs].present?
          values = results[:grow_logs].map{|s| Struct.new(:time,:value).new(s["created_at"] , s["val1"] ) }
          Struct.new(:time_unit, :sensor, :values).new(
              args[:time_unit],
              args[:sensor],
              values
            )
        else 
          Struct.new(:time_unit, :sensor, :values).new(nil,nil,Struct.new(:time,:value).new(nil,nil))
        end
      }
    end
  
  end

  
end

