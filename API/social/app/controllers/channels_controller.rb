class ChannelsController < ApplicationController
  # layout 'admin'
  before_filter :check_admin,  :except => [:index, :show, :get_programmes, :private, :public]
  before_filter :require_login, :only =>[:private, :public]
  before_filter :Message
  respond_to :html, :json, :xml
  $latest_channels = []
  def new
    @channel = Channel.new
  end

  def index
    @channels = Channel.all
    output = { 'status' => 'success', 'data' => @channels}
    respond_to do |format|
      format.html {}
      format.json { render json: output, :methods => [:image_url] }
      format.xml { render xml: output, :methods => [:image_url] }
    end
    
  end

  def create
    @channel = Channel.new(params[:channel])
    if @channel.save
      message = 'Channel saved successfully.'
      output = { 'status' => 'success', 'message' => message, 'data' => @channel}
      respond_to do |format|
        format.html {redirect_to channels_path, :notice => message}
        format.json { render json: output, status: :created }
        format.xml { render xml: output, status: :created }
      end
    else
      message = @channel.errors.full_messages
      output = { 'status' => 'failure', 'message' => message }
      respond_to do |format|
        format.html {redirect_to channels_path, :notice => message}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    end
    
  end

  def destroy
    begin
      @channel = Channel.find(params[:id])
      if  @channel.destroy
        message = 'Removed Channel.'
        output = { 'status' => 'success', 'message' => message}
      else
        message = @channel.errors
        output = { 'status' => 'success', 'message' => message}
      end
    rescue
      message = 'Invalid Id Or Id not Found'
      output = { 'status' => 'failure', 'message' => message}
    end

    respond_to do |format|
      format.html {redirect_to channels_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end

  end

  def edit
    @channel = Channel.find(params[:id])
  end

  def update
    begin
      @channel = Channel.find(params[:id])

      if @channel.update_attributes(params[:channel])
        message = 'Wow! Channel has been updated successfully.'
        output = { 'status' => 'success', 'message' => message, 'data' => @channel}
      else
        message = @channel.errors.full_messages
        output = { 'status' => 'success', 'message' => message}
      end
    rescue
      message = 'Invalid Id Or Id not Found'
      output = { 'status' => 'failure', 'message' => message}
    end

    respond_to do |format|
      format.html {redirect_to channels_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
  end

  def show
    begin
      @channel = Channel.find(params[:id])
      output = { 'status' => 'success', 'data' => @channel}
      respond_to do |format|
        format.html {}
        format.json { render json: output, status: :created }
        format.xml { render xml: output, status: :created }
      end
    rescue
      message = 'Invalid Id Or Id not Found'
      output = { 'status' => 'failure', 'message' => message}
      respond_to do |format|
        format.html {redirect_to channels_path, :notice => message}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    end

  end

  def get_programmes
    begin
      @channel = Channel.find(params[:id])
      programmes = Programme.where(:channel_id=>params[:id]).order(:name) unless params[:id].blank?
      output = { 'status' => 'success', 'data' => programmes}
    rescue
      message = 'Invalid Id Or Id not Found'
      output = { 'status' => 'failure', 'message' => message}  
    end

    respond_to do |format|
      format.html { render :partial => "shared/programmes", :locals => { :programmes => programmes }}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end

  end
  
    def private
      get_channels('private')
    end
    
    
    def public
      get_channels('public')
    end
    
    private
    def get_channels(type)
      current_user_view_channel_id = current_user.currently_view_channel_id
      channels = Channel.all # fetch all channels
      if type == 'private'
        friends_ids = current_user.friendships.pluck(:friend_id) # pluck used for to select one attributes
        friends_ids << current_user.id
      end       
      
      @currently_view = []
      threads = []
      # channels loop start here
      channels.each do |c|
         threads << Thread.new { get_latest_channel(type, c, current_user_view_channel_id, friends_ids)}
      end
      # channels loop end here
      threads.each do |t|
        t.join
      end
      
      # first sort an array in asceding order depending on message id than reverse it
      $latest_channels = $latest_channels.sort {|a,b| a['message_id'] <=> b['message_id']}.reverse
      
      # rearrange an array if logging user is currently view any channel
      if current_user_view_channel_id
        temp = []
        $latest_channels.each do |ch|
          if ch['id'] == current_user_view_channel_id && ch['message_id'] != 0
            temp << {'id' => ch['id'], 'name' => ch['name'], "message_id" => ch['message_id'], 'image_file_name' => ch['image_file_name'], 'image_url' => ch['image_url']}
            $latest_channels.reject!{|a| a == ch}
            $latest_channels.unshift(temp.first)
          end
        end
      end
      @channels = $latest_channels
      output = { 'status' => 'Success', 'currently_view' => @currently_view, 'data' => $latest_channels}
          
      respond_to do |format|
        format.html {}
        format.json { render json: output }
        format.xml { render xml: output}
      end
    end
    
    private
    def get_latest_channel(type, c, current_user_view_channel_id, friends_ids)
      if type == 'private'
        condition = { :user_id => friends_ids, :status => true, :channel_id => c.id }
      else
        condition = { :view_ability => 'Public', :status => true, :channel_id => c.id }
      end   
      @msgs = Message.find(:all, :conditions => condition, :order => "id DESC", :limit => 1)
      
      msg_id = 0
      @msgs.each do |m| # @msgs is an array 
        msg_id = m.id
      end
         
      if c.id == current_user_view_channel_id # saveing currently view channel detail for a logged in user
        @currently_view << {'channel_id' => c.id, 'channel_name' => c.name}
      end
     
      image_url = "/system/channels/missing.png"
      if c.image_file_name
        image_url =  "/system/channels/images/#{c.id}/original/#{c.image_file_name}"
      end
     
      ch = {'id' => c.id, 'name' => c.name, "message_id" => msg_id, 'image_file_name' => c.image_file_name, 'image_url' => image_url}
      # check if ch object exists in array       
      unless $latest_channels.include?(ch)
         $latest_channels << ch # pushing in channels array
      end
      
    end

end
