json.array!(@brands) do |brand|
  json.extract! brand, :id, :name, :category, :brandpic
  json.url brand_url(brand, format: :json)
end
