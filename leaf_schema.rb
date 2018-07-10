LeafSchema = GraphQL::Schema.define do
 
  use GraphQL::Guard.new( 
    not_authorized: ->(type, field) { GraphQL::ExecutionError.new("Access Denied on #{type}.#{field}") }
  )


  # Bind All Queries 
  query(
    GraphQL::ObjectType.new.tap do |root|
      root.name = "Query"
      root.description = "The query root of this schema"
      queries =  
        [
          Schema::Queries::AssetQuery,
          Schema::Queries::DailyReportsQuery,
          Schema::Queries::GrowLogsQuery,
          Schema::Queries::GrowsQuery,
          Schema::Queries::LeafBoxesQuery,
          Schema::Queries::RecipesQuery,
          Schema::Queries::SensorDataQuery,
          Schema::Queries::UsersQuery,
        ]
      root.fields = Array(queries).inject({}) do |acc, query_type|
        acc.merge!(query_type.fields)
      end
    end
    )

  # Bind all Mutations
  mutation(
    GraphQL::ObjectType.new.tap do |root|
      root.name = "Mutation"
      root.description = "The mutation root of this schema"
      mutation_types = [
          Schema::Mutations::GrowMutation,
          Schema::Mutations::LeafBoxMutation,
          Schema::Mutations::LeafBoxEventMutation,
          Schema::Mutations::UserMutation 
        ]
      root.fields = Array(mutation_types).inject({}) do |acc, query_type|
        acc.merge!(query_type.fields)
      end
    end
    ) 

end
