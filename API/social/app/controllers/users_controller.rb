class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]
 
  respond_to :html, :json, :xml
  def index
    @users = User.all
    if current_user
      @friends = Friendship.where("user_id = ?", current_user.id)
    end
    output = { 'status' => 'success', 'data' => @users}
    respond_to do |format|
      format.html {}
      format.json { render json: output, :methods => [:photo_url], status: :unprocessable_entity }
      format.xml { render xml: output, :methods => [:photo_url], status: :unprocessable_entity }
    end
  end

  def new
  end
  
  def search
    @users = User.search(params[:search])
    if current_user
      @friends = Friendship.where("user_id = ?", current_user.id)
    end
    
    if @users.present?
      output = { 'status' => 'success', 'data' => @users}
    else
      output = { 'status' => 'success', 'data' => @users, 'message' => 'No users found.'}
    end    
    respond_to do |format|
      format.html {}
      format.json { render json: output}
      format.xml { render xml: output }
    end
  end

  # def create
    # #@user = User.new(params[:user])
    # logger.debug "create user: #{params[:user]}"
    # # logger.debug "without user: #{params}"
# 
    # @user = User.new(params[:user])
# 
    # respond_to do |format|
      # if @user.save
        # output = { 'status' => 'success', 'data' => @user}
        # format.json { render json: output, status: :created }
        # format.xml { render xml: output, status: :created }
      # else
        # output = { 'status' => 'failure', 'message' => @user.errors}
        # format.json { render json: output, status: :unprocessable_entity }
        # format.xml { render xml: output, status: :unprocessable_entity }
      # end
    # end
  # end

  def show
    begin
      @user = User.find(params[:id])
      output = { 'status' => 'success', 'data' => @user}
      respond_to do |format|
      format.html {}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
    rescue
      message = 'Invalid Id Or Id not Found'
      output = { 'status' => 'failure', 'message' => message}
      respond_to do |format|
      format.html {redirect_to users_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
    end

    
  end

  def destroy
  end

  def sign_in
    redirect_to new_user_session_path
  end
  
  # def update
    # @user = User.find(params[:id])
# 
    # respond_to do |format|
      # if @user.update_attributes(params[:user])
        # output = { 'status' => 'success', 'data' => @user, :auth_token => @user.authentication_token}
        # format.html {redirect_to new_user_session_path, :notice => "Registration done successfully"}
        # format.json { render json: output, status: :created }
        # format.xml { render xml: output, status: :created }
      # else
        # output = { 'status' => 'failure', 'notice' => @user.errors}
        # format.html {redirect_to new_user_registration_path, 'message' => @user.errors.full_messages}
        # format.json { render json: output, status: :unprocessable_entity }
        # format.xml { render xml: output, status: :unprocessable_entity }
      # end
    # end
  # end
  
end
