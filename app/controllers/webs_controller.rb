class WebsController < ApplicationController
  # before_action :set_web, only: %i[ show edit update destroy ]

  # GET /webs or /webs.json
  
def all_schedule_meetings
   

  end

  def index
    @webs = Web.all
    if params[:code].present?
      require "uri"
      require "net/http"

      url = URI("https://webexapis.com/v1/meetings")

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer M2RhNDI2MjAtOGYzMy00NjIyLTg4Y2UtY2IwYThjZTQyNjIwMThiZWZkZTEtZjI4_P0A1_a5f91689-712e-402d-aa9f-0e4101389783"
      request.body = JSON.dump({
      "client_id": ENV["CLIENT_ID"],
      "client_secret": ENV["CLIENT_SECRET"],
      "code": "#{params[:code]}",
      "redirect_uri": root_path,
      "grant_type": "authorization_code"
      })

      response = https.request(request)
      puts response.read_body
    end
      require "uri"
      require "net/http"
      url = URI("https://webexapis.com/v1/meetings")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer OGJhOTUyZGEtMWM5NS00NWVhLTgxZTYtMDJhZDg0MDE2ODY3ZmVjZmNjYWEtNDky_P0A1_a5f91689-712e-402d-aa9f-0e4101389783"
      request["Cookie"] = "trackingSessionID=DAFAE70AD187420FAA7E74027D80AAB8"
      # request.body = "{\n    \"title\": \"Example Daily Meeting\",\n    \"agenda\": \"Example Agenda\",\n    \"password\": \"BgJep@43\",\n    \"start\": \"2022-04-02T20:30:00-08:00\",\n    \"end\": \"2022-04-02T20:50:00-08:00\",\n    \"enabledAutoRecordMeeting\": false,\n    \"allowAnyUserToBeCoHost\": false\n}"
      response = https.request(request)
      puts response.read_body
      @webs = JSON.parse(response.read_body)["items"]

  end

  # GET /webs/1 or /webs/1.json
  def show
  end

  # GET /webs/new
  def new
    @web = Web.new
  end

  # GET /webs/1/edit
  def edit
  end

  # POST /webs or /webs.json
  def create
    @web = Web.new(web_params)

    require "uri"
    require "net/http"

    url = URI("https://webexapis.com/v1/meetings")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer OGJhOTUyZGEtMWM5NS00NWVhLTgxZTYtMDJhZDg0MDE2ODY3ZmVjZmNjYWEtNDky_P0A1_a5f91689-712e-402d-aa9f-0e4101389783"
    request["Cookie"] = "trackingSessionID=DC0EA3A30DB2488EBF423C341731EC79"
    request.body = JSON.dump({
      "title":  params[:web][:title],
      "agenda":  params[:web][:agenda],
      "password": "BgJep@43",
      "start":  params[:web][:start],
      "end":  params[:web][:end],
      "enabledAutoRecordMeeting": false,
      "allowAnyUserToBeCoHost": false
    })
    response = https.request(request)
    puts response.read_body 
       redirect_to "/webs"
  end

  # PATCH/PUT /webs/1 or /webs/1.json
  def update
    respond_to do |format|
      if @web.update(web_params)
        format.html { redirect_to web_url(@web), notice: "Web was successfully updated." }
        format.json { render :show, status: :ok, location: @web }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @web.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webs/1 or /webs/1.json
  def destroy
    require "uri"
    require "net/http"
    url = URI("https://webexapis.com/v1/meetings/#{params[:id]}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Delete.new(url)
    request["Authorization"] = "Bearer M2RhNDI2MjAtOGYzMy00NjIyLTg4Y2UtY2IwYThjZTQyNjIwMThiZWZkZTEtZjI4_P0A1_a5f91689-712e-402d-aa9f-0e4101389783"
    request["Cookie"] = "trackingSessionID=11A97E57788C4AB98AE29868186079C0"
    response = https.request(request)
    puts response.read_body
    redirect_to "/webs"
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_web
      @web = Web.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def web_params
      params.require(:web).permit(:meeting,:title, :agenda, :password, :start, :end, :allowAnyUserToBeCoHos)
    end
end
