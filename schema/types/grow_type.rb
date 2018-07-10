module Schema
  Types::GrowType = GraphQL::ObjectType.define do
      name "Grow"
      #guard ->(obj, args, ctx) { ctx[:current_user].present? }
      field :id, types.ID
      field :user, Types::UserType
      field :recipe, Types::RecipeType
      field :leaf_box, Types::LeafBoxType
      field :active, types.Boolean 
      field :started_at, types.String
      field :ended_at, types.String 
      field :current_stage, Types::StageType do 
         resolve ->(obj, args, ctx) {
          if obj.recipe && obj.recipe.stages 
            duration_days = obj.current_stage_data["timeline"].map{|m| m["duration"] }.sum.to_f / 24.0
            Struct.new(:name,:symbol, :duration, :index)
            .new(obj.current_stage_data["name"],obj.current_stage_data["symbol"],duration_days, obj.current_stage_index)     
          end  
        }    
      end 
      field :stage_event_history, !types[Types::StageEventHistoryType] do 
        resolve ->(obj, args, ctx) {
          data = LeafBoxEvent.stage_event_history(obj.leaf_box , obj) 
        }
      end
      field :current_calendar_day, types.Int
      field :day, types.Int do    
         resolve ->(obj, args, ctx) {
          obj.grow_day_from_date(DateTime.now) + 1
        }
      end
      field :week, types.Int do 
        resolve ->(obj, args, ctx) {
          obj.grow_week_from_date(DateTime.now)
        }
      end
     # field :daily_photos, !types[types.String]
      field :daily_photos, !types[Types::PhotoType]
  end
end

