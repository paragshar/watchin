class FriendsController < ApplicationController
  # skip_before_filter :verify_authenticity_token, :only => [:create]
  # before_filter :authenticate_user!
  respond_to :html, :json, :xml
  def index
    # Friend.joins('LEFT OUTER JOIN users ON users.id = friends.friend_id')
    # @friends = Friend.where("user_id = ?", current_user.id)
    @friends =  Friend.find_by_sql("SELECT * FROM users LEFT JOIN friends ON users.id=friends.friend_id WHERE friends.user_id= #{current_user.id}")
    # @friends = Friend.find_all_by_user_id(current_user.id)
    output = { 'status' => 'success', 'data' => @friends}
    respond_with output
  end

  def new
    @user = User.all
  end

  def create
    check_friend = Friend.where("user_id = ? AND friend_id = ?", current_user.id, params[:friend][:friend_id]).blank?
    if check_friend
      @friend = Friend.new(:user_id => current_user.id, :friend_id => params[:friend][:friend_id])
      if @friend.save
        output = { 'status' => 'success', 'data' => @friend}
      else
        output = { 'status' => 'failure', 'message' => @friend.errors}
      end

    else
      output = { 'status' => 'Failure', 'message' => "Already in friend List"}
    end

    respond_to do |format|
      format.html {redirect_to users_path, :message => @friend.errors}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end

   # logger.debug "without user: #{@friend}"
  end

  def edit

  end

  def update

  end

  def show

  end

  def destroy
    @friend = Friend.find(params[:id])
    if @friend.destroy
      output = { 'status' => 'success', 'message' => "Friend removed from friend list"}
    else
      output = { 'status' => 'failure', 'message' => @friend.errors}
    end
    # respond_with output
    
     respond_to do |format|
      format.html {redirect_to users_path}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
  end
end
