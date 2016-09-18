json.array!(@cities) do |city|
  json.extract! city, :id, :region, :departement, :zip, :name
  json.url city_url(city, format: :json)
end
