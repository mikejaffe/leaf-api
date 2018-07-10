module Schema
  Types::DeviceTypeType = GraphQL::ObjectType.define do
    name "DeviceType"

    field :id, types.ID 
    field :user, TYPES::UserType
    field :platform, types.String
    field :os_version, types.String
    field :model, types.String
    field :manufacturer, types.String
    field :app_version, types.String 
  end
  
end
