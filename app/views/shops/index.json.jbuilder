json.array!(@shops) do |shop|
  json.extract! shop, :id, :brand_id, :address, :zipcode, :city, :drive, :name
  json.url shop_url(shop, format: :json)
end
