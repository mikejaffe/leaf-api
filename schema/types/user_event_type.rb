module Schema
  Types::UserEventType = GraphQL::ObjectType.define do
    name "UserEventType"

    field :id, types.ID
    field :notification, Types::NotificationType
    field :grow, Types::GrowType
    field :user, Types::UserType 
    field :leaf_box, Types::LeafBoxType
    field :recipe, Types::RecipeType
    field :action, types.String
    field :value, types.String
    field :updated_at, Types::DateTimeType
    field :hidden, types.Boolean
    field :grow_stage, types.String
    field :read, types.Boolean
  end
end
