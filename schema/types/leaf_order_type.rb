module Schema
  Types::LeafOrderType = GraphQL::ObjectType.define do
    name "LeafOrder"
    guard ->(obj, args, ctx) { ctx[:current_user].present? }
    
    field :id, types.ID
    field :transaction_id, types.String
    field :tracking_number, types.String
    field :ship_at, types.String
    field :created_at, types.Boolean 
    field :balance_due, types.Float 
    field :warranty, Types::WarrantyType
    field :item_name, types.String do 
      resolve ->(obj, args, ctx) {
        obj.shopify_data["line_items"].first["title"]
      } 
    end
  end
end
