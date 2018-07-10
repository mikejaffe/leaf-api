module Schema
  Types::StageDurationType = GraphQL::ObjectType.define do
    name "StageDuration"

    field :id, types.ID
    field :days, types.Float do 
      resolve -> (obj, args, ctx) {
        obj.grow_hours / 24
      }
    end
    field :order, types.Int 
    field :nutrients, !types[Types::StageNutrientType] do 
      resolve -> (obj, args, ctx) {
        obj.stage_nutrients
      }
      
    end
  end
end
