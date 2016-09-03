json.array!(@users) do |user|
  json.extract! user, :id, :username, :admin, :nom, :prenom, :comment, :subscribe
  json.url user_url(user, format: :json)
end
