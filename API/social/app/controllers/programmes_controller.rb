class ProgrammesController < ApplicationController
  before_filter :check_admin,  :except => [:index, :show]
  respond_to :html, :json, :xml
  def index
    @programmes = Programme.all
    output = { 'status' => 'success', 'data' => @programmes}
    respond_to do |format|
      format.html { }
      format.json { render json: output, :include => [:channel]}
      format.xml { render xml: output, :include => [:channel] }
    end
  end

  def new
    @programme = Programme.new
    @channels = Channel.all
  end

  def create
    @programme = Programme.new(params[:programme])
    begin
    @channel = Channel.find(params[:programme][:channel_id])
  
      if @programme.save
        message = 'Programme saved successfully.'
        output = { 'status' => 'success', 'message' => message, 'data' => @programme}

      else
        message = @programme.errors.full_messages
        output = { 'status' => 'failure', 'message' => message }
      end
    rescue
      message = "Invalid Channel Id."
      output = { 'status' => 'failure', 'message' => message }
    end
    respond_to do |format|
      format.html {redirect_to programmes_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
  end

  def destroy
    begin
      @programme = Programme.find(params[:id])
      if  @programme.destroy
        message = 'Removed Programme.'
        output = { 'status' => 'success', 'message' => message}
      else
        message = @programme.errors
        output = { 'status' => 'success', 'message' => message}
      end
    rescue
      message = 'Invalid Id Or Id not Found'
      output = { 'status' => 'failure', 'message' => message}
    end

    respond_to do |format|
      format.html {redirect_to programmes_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end

  end

  def edit
    @programme = Programme.find(params[:id])
    @channels = Channel.all
  end

  def update
    begin
      @programme = Programme.find(params[:id])
       @channel = Channel.find(params[:programme][:channel_id])
      if @programme.update_attributes(params[:programme])
        message = 'Wow! Programme has been updated successfully.'
        output = { 'status' => 'success', 'message' => message, 'data' => @programme}
      else
        message = @programme.errors.full_messages
        output = { 'status' => 'success', 'message' => message}
      end
    rescue
      message = 'Invalid Programe Id Or Channel Id.'
      output = { 'status' => 'failure', 'message' => message}
    end

    respond_to do |format|
      format.html {redirect_to programmes_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
  end

  def show
    begin
      @programme = Programme.find(params[:id])
      p_list = []
      # @programmes.each do |p|
      # p_list << {'channel Name' => @programme.channel.name,}
      p_list << {'id' => @programme.id, 'name' => @programme.name, 'channel_id' => @programme.channel_id, 'channel_name' => @programme.channel.name, 'created_at' => @programme.created_at, 'updated_at' => @programme.updated_at}
      # end
      output = { 'status' => 'success', 'data' => p_list}
      respond_to do |format|
        format.html {}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    rescue
      message = 'Invalid Id Or Id not Found'
      output = { 'status' => 'failure', 'message' => message}
      respond_to do |format|
        format.html {redirect_to programmes_path, :notice => message}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    end

  end
end
