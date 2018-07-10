module Schema
  Types::StageNutrientType = GraphQL::ObjectType.define do
    name "StageNutrient"

    field :id, types.ID 
    field :units_per_ml, types.Float
    field :name, types.String do 
      resolve -> (obj, args, ctx ) {
        obj.nutrient.name 
      }
    end
  end
end
