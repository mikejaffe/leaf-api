module Schema
  Types::NotificationType = GraphQL::ObjectType.define do
    name "NotificationType"
    guard ->(obj, args, ctx) { ctx[:current_user].present? }
    
    field :id, types.ID
    field :owner_id, types.ID 
    field :owner_type, types.String
    field :message_type, types.String 
    field :subject, types.String 
    field :message, types.String
  #  field :options, Types::JsonType
    field :options, types.String do 
      resolve -> (obj, args, ctx) {
        obj.options.to_json
      }
    end
  end
end
