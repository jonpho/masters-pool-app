json.extract! golfer, :id, :player_id, :firstname, :lastname, :tour, :status, :created_at, :updated_at
json.url golfer_url(golfer, format: :json)
