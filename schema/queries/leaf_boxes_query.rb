module Schema
  Queries::LeafBoxesQuery = GraphQL::ObjectType.define do
    
    field :leaf_box, Types::LeafBoxType  do
      description "An instance of a leaf box."
      argument :id, types.ID 
      argument :photon_id, types.String 
      resolve ->(obj, args, ctx) {
        leaf_box = args[:id].present? ? LeafBox.find(args[:id]) : LeafBox.find_by_photon_id(args[:photon_id])
      }
    end
    
    field :leaf_boxes, !types[Types::LeafBoxType] do
      description "A list of leaf boxes."
      resolve ->(obj, args, ctx) {
        ctx[:current_user].leaf_boxes.includes( { current_grow: :recipe }, :latest_log, :latest_photo)
      }
    end  

    field :event_logs, !types[Types::EventLogType] do
      description "A list of leaf event logs."
      argument :leaf_box_id, !types.ID 
      argument :grow_id, !types.ID 
      argument :limit, !types.Int
      resolve ->(obj, args, ctx) {
        LeafBoxEvent.select("id,leaf_box_id, grow_id,public_action as action, public_value as value,read,created_at").where(public: true, leaf_box_id: args[:leaf_box_id], grow_id: args[:grow_id]).order("created_at desc").limit(args[:limit])
      }
    end  


    field :temp_store, types.String do
      description "Retrieves temp data from redis"
        argument :key, types.String
       redis = Redis.new(host: ENV["REDIS_ENDPOINT"])
       resolve ->(obj, args, ctx) {
       data = redis.get(args[:key]) || '["nodata", "found"]'
       JSON.parse(data).join(",")
      }
    end
  end

  
end

