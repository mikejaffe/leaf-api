module Schema
  Queries::RecipesQuery = GraphQL::ObjectType.define do
    
    field :recipe, Types::RecipeType  do
      description "An instance of a recipe."
      argument :id, !types.ID 
      resolve ->(obj, args, ctx) {
         Recipe.published.find(args[:id])
      }
    end
    
    field :recipes, !types[Types::RecipeType] do
      description "A list of recipes."
      argument :recipe_type, types.String
      argument :recipe_class, types.String
      resolve ->(obj, args, ctx) {
          recipies = Recipe.published
          recipies = recipies.where(recipe_type: args[:recipe_type]) if args[:recipe_type].present?
          recipies = recipies.where(recipe_class: args[:recipe_class]) if args[:recipe_class].present?
          recipies
      }
    end  
  end

  
end

