json.extract! meeting, :id, :meeting, :created_at, :updated_at
json.url meeting_url(meeting, format: :json)
