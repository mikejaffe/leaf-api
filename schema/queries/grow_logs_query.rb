module Schema
  Queries::GrowLogsQuery = GraphQL::ObjectType.define do
    
    field :grow_log, Types::GrowLogType  do
      description "An instance of a log."
      argument :id, !types.ID 
      resolve ->(obj, args, ctx) {
        GrowLog.find(args[:id])
      }
    end
    
    field :grow_logs, !types[Types::GrowLogType] do
      description "A list of grow logs."
      argument :leaf_box_id, types.ID 
      resolve ->(obj, args, ctx) {
        GrowLog.where(leaf_box_id: args[:leaf_box_id]).order("created_at desc")
      }
    end  
  end

  
end

