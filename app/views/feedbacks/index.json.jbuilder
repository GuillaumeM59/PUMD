json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :id, :bid_id, :driver_id, :pass_id, :score, :comment
  json.url feedback_url(feedback, format: :json)
end
