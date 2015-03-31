json.array!(@locations) do |location|
  json.extract! location, :id, :user_id, :longitude, :latitude
  json.url location_url(location, format: :json)
end
