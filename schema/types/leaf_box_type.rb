module Schema
  Types::LeafBoxType = GraphQL::ObjectType.define do
    name "LeafBox"
    #guard ->(obj, args, ctx) { ctx[:current_user].present?}

    field :id, types.ID
    field :serial, types.String
    field :name, types.String 
    field :photon_id, types.String
    field :latest_photo, types.String do 
      resolve ->(obj, args, ctx) {
        obj.photos.order("created_at desc").limit(1).first.file.url rescue nil 
      }
    end
    field :live_stream_url, types.String
    field :current_grow, Types::GrowType
    field :last_event, Types::LeafBoxEventType do 
      resolve ->(obj, args, ctx) {
        obj.latest_log
      }
    end
    field :time_zone, types.String
    field :created_at, types.String do 
      resolve ->(obj, args, ctx) {
        obj.created_at.in_time_zone(obj.time_zone)
      }
    end
    field :user, Types::UserType
    field :light_status, types.String
    field :camera_status, types.String
    field :door_status, types.String
    field :water_fill, types.String do 
      resolve ->(obj, args, ctx) {
        "Automatic"
      }
    end
    field :water_drain, types.String do 
      resolve ->(obj, args, ctx) {
        "Automatic"
      }
    end
    field :leaf_box_firmware, types.String
    field :leaf_order_id, types.Int
    field :unread_events_count, types.Int do 
      resolve ->(obj, args, ctx) {
        LeafBoxEvent.where(public: true, read: false, leaf_box_id: obj.id, grow_id: obj.current_grow.id).count  rescue 0  
     }
    end
  end
end
