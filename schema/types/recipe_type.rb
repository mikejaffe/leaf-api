module Schema
  Types::RecipeType = GraphQL::ObjectType.define do
    name "Recipe"
    #guard ->(obj, args, ctx) { ctx[:current_user].present? }
    
    field :id, types.ID
    field :name, types.String
    field :recipe_type, types.String
    field :recipe_class, types.String
    field :published, types.Boolean 
    field :light_hours_on, types.Int 
    field :light_hours_off, types.Int
    field :nutrients, types[Types::StageNutrientType]
    field :total_days, types.Float do 
      resolve -> (obj, args, ctx) {
        obj.grow_days rescue nil
      }
    end
    field :stages, types.String do 
      resolve -> (obj, args, ctx) {
        obj.stages.to_json
      }
    end
  end
end
