class FriendshipsController < ApplicationController
  respond_to :html, :json, :xml
  def index
    @friends = current_user.friendships
    frnd_list = []
    @friends.each do |frnd|
      frnd_list << {'friendship_id' => frnd.id, 'name' => frnd.friend.name, 'email' => frnd.friend.email, 'user_id' => frnd.friend.id, 'created_at' => frnd.friend.created_at, 'updated_at' => frnd.friend.updated_at}
    end
    output = { 'status' => 'success', 'data' => frnd_list}
    respond_with output

  # respond_to do |format|
  # format.html do
  #
  # end
  # format.json  do
  # self.friends
  # # render :json => { :status => 'success', :auth_token => current_user.authentication_token, :user => current_user }.to_json, :status => :ok
  # end
  # format.xml  do
  # self.friends
  # # render :json => { :status => 'success', :auth_token => current_user.authentication_token, :user => current_user }.to_json, :status => :ok
  # end
  # end

  end

  def create
    check_friend = current_user.friendships.where(:friend_id => params[:friend_id]).blank?
    if check_friend
      @friendship1 = current_user.friendships.build(:friend_id => params[:friend_id])
      params[:friendship2] = {:user_id => params[:friend_id], :friend_id => current_user.id}
      @friendship2 = Friendship.create(params[:friendship2])
      if @friendship1.save && @friendship2.save
        @friendship_request = FriendshipRequest.where("user_id = ? AND friend_id = ?", params[:friend_id], current_user.id)

        # logger.debug "without user: #{@friendship_request.friend.id}"
        @friendship_request.first.destroy
        message = "Added friend."
        output = { 'status' => 'success', 'message' => message}
      # redirect_to users_path
      else
        message = @friendship1.errors
        output = { 'status' => 'failure', 'message' => message}
      # redirect_to users_path
      end
    else
      message = "Already in friend list."
      output = { 'status' => 'failure', 'message' => message}
    # redirect_to users_path
    end
    respond_to do |format|
      format.html {redirect_to users_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end

  # respond_with output
  end

  def destroy
    @friendship1 = current_user.friendships.find(params[:id])
    @friendship2 = Friendship.find_by_user_id_and_friend_id(@friendship1.friend.id, current_user.id)
    if  @friendship1.destroy && @friendship2.destroy
      message = 'Removed Friendship'
      output = { 'status' => 'success', 'message' => message}
    else
      message = @friendship1.errors
      output = { 'status' => 'success', 'message' => message}
    end
    respond_to do |format|
      format.html {redirect_to current_user, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end

  end

  def friends

    
  end
end
