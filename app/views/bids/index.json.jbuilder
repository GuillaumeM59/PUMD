json.array!(@bids) do |bid|
  json.extract! bid, :id, :shop_id, :driver_id, :go_at, :come_back, :pass1_id, :pass2_id, :pass3_id, :pass4_id, :cangodrive
  json.url bid_url(bid, format: :json)
end
