json.array!(@validations) do |validation|
  json.extract! validation, :id, :bid_id, :driver_id, :pass_id, :code, :validated
  json.url validation_url(validation, format: :json)
end
