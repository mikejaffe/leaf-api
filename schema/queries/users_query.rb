module Schema
  Queries::UsersQuery = GraphQL::ObjectType.define do

    field :user, Types::UserType do 
      description "Leaf current user"
      guard ->(obj, args, ctx) { ctx[:current_user].present? } 
      resolve ->(obj, args, ctx) {
        ctx[:current_user] 
      } 
    end

    field :user_events, !types[Types::UserEventType] do 
      guard ->(obj, args, ctx) { ctx[:current_user].present? } 
      argument :stage, types.String
      argument :grow_id, !types.Int
      #argument :user_processed, types.Boolean
     # argument :hidden, types.Boolean
      resolve ->(obj, args, ctx) {
        
        user_events = UserEvent.where(hidden: false, user_id: ctx[:current_user].id, processed_date: nil, grow_id: args[:grow_id]).order("created_at")
        #value = (args[:user_processed].present? && args[:user_processed]) ? "not null" : "null"

        if args[:stage].present?
          user_events = user_events.where(grow_stage: args[:stage])
        end
        user_events
      }
    end
  
  end

end

