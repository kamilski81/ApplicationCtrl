json.array!(@teams) do |team|
  json.extract! team, :name, :description
  json.url team_url(team, format: :json)
end
