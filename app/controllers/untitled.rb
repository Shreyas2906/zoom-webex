url = URI("https://zoom.us/oauth/token?grant_type=authorization_code&code=#{params[:code]}&redirect_uri=http://localhost:3000/")
https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true
https.read_timeout = 1
request = Net::HTTP::Post.new(url)
auth_header = Base64.strict_encode64("LFkqqeVlSPuJeT1mLGVsPA:y2gpfvraVx6XH0T7tq95P6UZ3X8QwbzY")
request["Content-Type"] = "application/atom+xml"
request["Authorization"] = "Basic #{auth_header}"
response = https.request(request)
puts response.read_body


https://webexapis.com/v1/authorize?client_id=C5ec2f12bc1d9ba792540a19b85ca31dd28a4ae6f56de9223a51ae125a742dcc8&response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A3000&scope=meeting%3Arecordings_read%20spark%3Aall%20meeting%3Aadmin_schedule_write%20meeting%3Aschedules_read%20meeting%3Apreferences_write%20spark-admin%3Apeople_write%20meeting%3Arecordings_write%20meeting%3Apreferences_read%20meeting%3Aadmin_recordings_read%20spark-admin%3Aorganizations_read%20spark-admin%3Aplaces_read%20spark-admin%3Aresource_group_memberships_read%20meeting%3Aschedules_write%20spark%3Akms%20spark-admin%3Adevices_read%20meeting%3Aadmin_recordings_write%20spark-admin%3Aplaces_write%20spark-admin%3Alicenses_read%20meeting%3Aadmin_schedule_read%20spark-admin%3Adevices_write%20spark-admin%3Apeople_read&state=set_state_here



{"access_token":"OGJhOTUyZGEtMWM5NS00NWVhLTgxZTYtMDJhZDg0MDE2ODY3ZmVjZmNjYWEtNDky_P0A1_a5f91689-712e-402d-aa9f-0e4101389783","expires_in":1209599,"refresh_token":"OGNjM2NkOTUtOGFjZi00ZGEyLThmMWMtZGVhZjEyNmNjMWE4ODhiNjkxNGYtZWEw_P0A1_a5f91689-712e-402d-aa9f-0e4101389783","refresh_token_expires_in":7774686,"token_type":"Bearer"}