json.array!(@coins) do |coin|
  json.extract! coin, :id, :user_id, :bid_id, :comment1, :comment2
  json.url coin_url(coin, format: :json)
end
