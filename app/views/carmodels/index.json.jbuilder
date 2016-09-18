json.array!(@carmodels) do |carmodel|
  json.extract! carmodel, :id, :brand_id, :name
  json.url carmodel_url(carmodel, format: :json)
end
