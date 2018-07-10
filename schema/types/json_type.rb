module Schema
  Types::JsonType = GraphQL::ScalarType.define do
    name "JSON"
    coerce_input -> (x) { JSON.parse(x) }
    coerce_result -> (x) {  x }
  end
end