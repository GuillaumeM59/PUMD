json.array!(@carbrands) do |carbrand|
  json.extract! carbrand, :id, :name
  json.url carbrand_url(carbrand, format: :json)
end
