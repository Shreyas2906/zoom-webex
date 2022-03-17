require 'zoomus'

class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[ show edit update destroy ]

  # GET /meetings or /meetings.json
  
def all_schedule_meetings
    require "uri"
    require "net/http"
    event_provider = EventProvider.last
    @access_token = event_provider.access_token
    @refresh_token = event_provider.refresh_token
    url = URI("https://api.zoom.us/v2/users/#{user_id}/meetings?type=#{params[:type]}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    https.read_timeout = 1
    request = Net::HTTP::Get.new(url)
    auth_header = Base64.strict_encode64("LFkqqeVlSPuJeT1mLGVsPA:y2gpfvraVx6XH0T7tq95P6UZ3X8QwbzY")
    request["Content-Type"] = "application/atom+xml"
    request["Authorization"] = "Bearer #{@access_token}"
    all_meetings = https.request(request)
    puts all_meetings.read_body
    @meetings = JSON.parse(all_meetings.read_body)
  end


  def index
    @meetings = Meeting.all
    if params[:code].present?
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
      response_data = JSON.parse(response.read_body)
      access_token = response_data["access_token"]
      expires_in = response_data["expires_in"]
      refresh_token = response_data["refresh_token"]
      # locale = locale
      # event_provider = Eventprovider.where(:name => "zoom").first_or_initialize
      event_provider = EventProvider.first_or_initialize
      # event_provider.provider = "zoom"
      event_provider.access_token = access_token
      event_provider.refresh_token = refresh_token
      event_provider.save
      redirect_to "/meetings/new"
    end
  end

  # GET /meetings/1 or /meetings/1.json
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings or /meetings.json
  # def create
  #   @meeting = Meeting.new(meeting_params)
  #   zoomus_client.meeting_create(merge_params(meeting_params))

  #   respond_to do |format|
  #     if @meeting.save
  #       format.html { redirect_to meeting_url(@meeting), notice: "Meeting was successfully created." }
  #       format.json { render :show, status: :created, location: @meeting }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @meeting.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def create
    # begin
      # zoomus_client.meeting_create(merge_params(meeting_params))
      event_provider = EventProvider.last
      @access_token = event_provider.access_token
      @refresh_token = event_provider.refresh_token
      url = URI("https://api.zoom.us/v2/users/#{merge_params(meeting_params)["host_id"]}/meetings")
      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{@access_token}"
      # request.body = {"topic": params[:meeting][:topic], "type": params[:meeting][:type].to_i, "start_time": params[:meeting][:start_time], "duration": params[:meeting][:duration], "timezone": params[:meeting][:timezone],"recurrence": {"end_date_time": params[:meeting][:end_date_time], "end_times":params[:meeting][:end_times], "monthly_day": params[:meeting][:monthly_day].to_i, "monthly_week": params[:meeting][:monthly_week].to_i, "monthly_week_day": params[:meeting][:monthly_week_day].to_i, "repeat_interval": 0, "meeting_type": params[:meeting][:meeting_type].to_i, "weekly_days": params[:meeting][:weekly_days]}}.to_json

      request.body = {"topic": params[:meeting][:topic], "type": params[:meeting][:type].to_i, "start_time": params[:meeting][:start_time], "duration": params[:meeting][:duration], "timezone": params[:meeting][:timezone], "recurrence": {"end_date_time": params[:meeting][:end_date_time], "monthly_day": params[:meeting][:monthly_day].to_i, "monthly_week": params[:meeting][:monthly_week].to_i, "monthly_week_day": params[:meeting][:monthly_week_day].to_i, "repeat_interval": 0, "type": params[:meeting][:meeting_type].to_i, "weekly_days": params[:meeting][:week_days]}}.to_json
      response = https.request(request)
      byebug
      puts response.read_body
      response_data = JSON.parse(response.read_body)
      Meeting.create(meeting: response_data["join_url"])  
       redirect_to "/meetings"
    # rescue Exception => e
    #   byebug
    #   { error: e.message }
    # end
  end

  # PATCH/PUT /meetings/1 or /meetings/1.json
  def update
    respond_to do |format|
      if @meeting.update(meeting_params)
        format.html { redirect_to meeting_url(@meeting), notice: "Meeting was successfully updated." }
        format.json { render :show, status: :ok, location: @meeting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1 or /meetings/1.json
  def destroy
    @meeting.destroy

    respond_to do |format|
      format.html { redirect_to meetings_url, notice: "Meeting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def zoomus_client
      @instance ||= Zoomus.new
    end

    def merge_params(params)
      params.merge({
        host_id: user_id,
        start_time: process_meeting_date(params[:start_time])
      })
    end

    def process_meeting_date(the_date)
      Time.parse(params[:meeting][:start_time]).strftime("%Y-%m-%dT%H:%M:%SZ") if params[:meeting][:start_time].present?
    end

    def user_id
      require "uri"
      require "net/http"
      event_provider = EventProvider.last
      @access_token = event_provider.access_token
      @refresh_token = event_provider.refresh_token
      url = URI("https://api.zoom.us/v2/users")
      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["Authorization"] = "Bearer #{@access_token}"
      response = https.request(request)
      puts response.read_body
      response = https.request(request)
      response_users = JSON.parse(response.read_body)["users"]
      account_user = []
      response_users.each do |user|
        if (user["email"] == "cuteshreya307@gmail.com")
          account_user << user
        end 
      end
      # response_user_id = account_user.last["id"]
      @user = account_user.last["id"]

      # @user ||= zoomus_client.user_getbyemail(email: "cuteshreya307@gmail.com")['id']
    end

    # Only allow a list of trusted parameters through.
    def meeting_params
      params.require(:meeting).permit(:start_time, :topic, :duration, :timezone, :type, :join_url, :monthly_day, :monthly_week, :end_date_time, :monthly_week_day, :weekly_days, :end_times, :meeting_type).to_h
    end
end
