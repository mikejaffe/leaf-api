module Schema
  Types::WarrantyType = GraphQL::ObjectType.define do
    name "WarrantyType"
    guard ->(obj, args, ctx) { ctx[:current_user].present? }
    
    field :id, types.ID
    field :start_at, types.String 
    field :end_at, types.String
    field :warranty_type, types.String do 
      resolve -> (obj, args, ctx) {
        "#{obj.extension_type + 1} yr"
      }
    end
  end
end
