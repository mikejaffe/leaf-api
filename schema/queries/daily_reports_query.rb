module Schema
  Queries::DailyReportsQuery = GraphQL::ObjectType.define do

    field :daily_report, Types::DailyReportType do 
      description "Leaf daily report"
      argument :leaf_box_id, !types.ID 
      argument :date, !types.String 
      guard ->(obj, args, ctx) { ctx[:current_user].present? } 
      resolve ->(obj, args, ctx) {
       leaf_box = LeafBox.find(args[:leaf_box_id])
       if leaf_box.blank? || leaf_box.current_grow.blank?
          GraphQL::ExecutionError.new("LeafBox does not exist, or Grow is not active.")
      else
        GrowLog.daily_report(leaf_box.id, args[:date], leaf_box.current_grow.id)
      end
      }   
    end
  
  end

end
