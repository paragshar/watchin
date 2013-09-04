class MessagesController < ApplicationController
  before_filter :require_login,  :except => [:show]
  respond_to :html, :json, :xml
  def index
    @messages = current_user.messages.all
    m_list = []
    @messages.each do |m|
      m_list << {'id' => m.id, 'message' => m.message, 'channel_id' => m.channel_id, 'channel_name' => m.channel.name, 'programme_id' => m.programme_id, 'programme_name' => m.programme.name, 'view_ability' => m.view_ability, 'created_at' => m.created_at, 'updated_at' => m.updated_at}
    end
    output = { 'status' => 'success', 'data' => m_list}
    respond_with output
  end

  def new
    @message = Message.new
    @channels = Channel.all
  end

  def create

    begin
      @message = current_user.messages.build(params[:message])
      check_programme = Programme.find_by_id_and_channel_id(params[:message][:programme_id], params[:message][:channel_id])
      if !check_programme.blank?
        if @message.save
          message = 'Message saved successfully.'
          output = { 'status' => 'success', 'message' => message, 'data' => @message}

        else
          message = @message.errors.full_messages
          output = { 'status' => 'failure', 'message' => message }
        end
      else
        message = "Invalid programme id OR channel id."
        output = { 'status' => 'failure', 'message' => message }
      end
    rescue
      message = "Invalid programme id OR channel id."
      output = { 'status' => 'failure', 'message' => message }
    end

    respond_to do |format|
      format.html {redirect_to messages_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
  end

  def show
    begin
      @message = Message.find(params[:id])
      message = []
      message << {'id' => @message.id, 'message' => @message.message, 'channel_id' => @message.channel_id, 'channel_name' => @message.channel.name, 'programme_id' => @message.programme_id, 'programme_name' => @message.programme.name, 'view_ability' => @message.view_ability, 'created_at' => @message.created_at, 'updated_at' => @message.updated_at}
      output = { 'status' => 'success', 'data' => message}
      respond_to do |format|
        format.html {}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    rescue
      message = 'Invalid Id Or Id not Found'
      output = { 'status' => 'failure', 'message' => message}
      respond_to do |format|
        format.html {redirect_to messages_path, :notice => message}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      @message = current_user.messages.find(params[:id])
      if @message.destroy
        message = 'Removed Message.'
        output = { 'status' => 'success', 'message' => message}
      else
        message = @message.errors
        output = { 'status' => 'success', 'message' => message}
      end
    rescue
      message = 'Invalid Id Or You are not authorize to delete this message.'
      output = { 'status' => 'failure', 'message' => message}
    end

    respond_to do |format|
      format.html {redirect_to messages_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end

  end

  def edit
    @channels = Channel.all

    @message = current_user.messages.find(params[:id])
    @programmes = Programme.where(:channel_id => @message[:channel_id])
  end

  def update
    begin
      @message = current_user.messages.find(params[:id])
      check_programme = Programme.find_by_id_and_channel_id(params[:message][:programme_id], params[:message][:channel_id])
      if check_programme
        if @message.update_attributes(params[:message])
          message = 'Wow! Message has been updated successfully.'
          output = { 'status' => 'success', 'message' => message, 'data' => @message}
        else
          message = @message.errors.full_messages
          output = { 'status' => 'success', 'message' => message}
        end
      else
        message = "Invalid programme id OR channel id."
        output = { 'status' => 'failure', 'message' => message }
      end

    rescue
      message = 'Invalid Id Or You are not authorize to update this message.'
      output = { 'status' => 'failure', 'message' => message}
    end

    respond_to do |format|
      format.html {redirect_to messages_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
  end

  def friends
    # begin
      @friends_ids = current_user.friendships.pluck(:friend_id) # pluck used for to select one attributes
      @friends_ids << current_user.id
      # @channels_ids = Message.where('(user_id in (:ids) or view_ability = (:ability)) and status = (:status)', 
               # :ids => @friends_ids, :ability => 'Public', :status => true).order('id DESC').pluck('programme_id')
      # @frnd_messages = Message.find_all_by_user_id_and_status(@friends_ids, true)
      
      # @frnd_messages=  Message.find(:all, :conditions => conditions, :order => "id DESC")
      # @frnd_messages=  Message.find(:all, :conditions => { :user_id => @friends_ids, :status => true}, :order => "id DESC")
      
      @frnd_messages=  Message.where('(user_id in (:ids) or view_ability = (:ability)) and status = (:status)', 
               :ids => @friends_ids, :ability => 'Public', :status => true).order('id DESC')
      
      # @frnd_messages = Message.find_all_by_user_id_and_status(@friends_ids, true, "Public")
      m_list = []
      @frnd_messages.each do |m|
        m_list << {'id' => m.id, 'friend_id' => m.user_id, 'friend_name' => m.user.name, 'friend_email' => m.user.email, 'message' => m.message, 'channel_id' => m.channel_id, 'channel_name' => m.channel.name, 'programme_id' => m.programme_id,  'created_at' => m.created_at, 'updated_at' => m.updated_at}
      end
      output = { 'status' => 'success', 'data' => m_list}
      respond_to do |format|
        format.html {}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    # rescue
      # message = 'No friends found OR No friends messages found.'
      # output = { 'status' => 'failure', 'message' => message}
      # respond_to do |format|
        # format.html {redirect_to messages_path, :notice => message}
        # format.json { render json: output, status: :unprocessable_entity }
        # format.xml { render xml: output, status: :unprocessable_entity }
      # end
    # end
  end
  
    # fetch friends message for a programme by programme id
    def friends_programme
      
      begin
        @programme = Programme.find(params[:id])
        @friends_ids = current_user.friendships.pluck(:friend_id) # pluch used for to select one or more attributes
        @frnd_messages = Message.find_all_by_user_id_and_status_and_programme_id(@friends_ids, true, @programme)
        # m_list = []
        # @frnd_messages.each do |m|
          # m_list << {'id' => m.id, 'friend_id' => m.user_id, 'friend_name' => m.user.name, 'friend_email' => m.user.email, 'message' => m.message, 'channel_id' => m.channel_id, 'channel_name' => m.channel.name, 'programme_id' => m.programme_id, 'programme_name' => m.programme.name, 'created_at' => m.created_at, 'updated_at' => m.updated_at}
        # end
        output = { 'status' => 'success', 'data' => @frnd_messages}
        respond_to do |format|
          format.html {}
          format.json { render json: output, :include => [:user, :channel, :programme], status: :unprocessable_entity }
          format.xml { render xml: output, :include => [:user, :channel, :programme], status: :unprocessable_entity }
        end
      rescue
        message = 'Invalid Programme Id.'
        output = { 'status' => 'failure', 'message' => message}
        respond_to do |format|
          format.html {redirect_to messages_path, :notice => message}
          format.json { render json: output, status: :unprocessable_entity }
          format.xml { render xml: output, status: :unprocessable_entity }
        end
      end
    end
    
    def private
      get_messages('private', 5)
    end
    
    def public
      get_messages('public', 5)
    end
    
    private
     def get_messages(type, limit)
       begin
        channel = Channel.find(params[:id])
        if type == 'private'
          friends_ids = current_user.friendships.pluck(:friend_id) # pluck used for to select one attributes
          friends_ids << current_user.id
          condition = { :user_id => friends_ids, :status => true, :channel_id => channel }
        else
          condition = { :view_ability => 'Public', :status => true, :channel_id => channel }
        end  
        @msgs = Message.find(:all, :conditions => condition, :order => "id DESC", :limit => limit)
        
        # m_list = []
        # @msgs.each do |m|
          # m_list << {'id' => m.id, 'message' => m.message, 'user_id' => m.user_id, 'user_name' => m.user.name, 'programme_id' => m.programme_id, 'programme_name' => m.programme.name, 'view_ability' => m.view_ability, 'created_at' => m.created_at, 'updated_at' => m.updated_at}
        # end
        
        output = { 'status' => 'Success', 'data' => @msgs}
         
        respond_to do |format|
          format.html { }
          format.json { render json: output, :include => [:user, :channel] }
          format.xml { render xml: output, :include => [:user, :channel] }
        end
      rescue
        message = 'Invalid Channel Id Or Channel Id is missing.'
        output = { 'status' => 'failure', 'message' => message}
        respond_to do |format|
          format.html {redirect_to messages_path, :notice => message}
          format.json { render json: output, status: :unprocessable_entity }
          format.xml { render xml: output, status: :unprocessable_entity }
        end
      end
     end 
     
end
