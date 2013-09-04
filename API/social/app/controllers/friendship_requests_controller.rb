class FriendshipRequestsController < ApplicationController
  respond_to :html, :json, :xml
  def index
    # @friend_requests = current_user.inverse_friend_requests
    @friend_requests = FriendshipRequest.find_all_by_friend_id(current_user.id)
    frnd_list = []
    @friend_requests.each do |frnd|
      frnd_list << {'friendship_request_id' => frnd.id, 'name' => frnd.user.name, 'email' => frnd.user.email, 'user_id' => frnd.user.id, 'created_at' => frnd.user.created_at, 'updated_at' => frnd.user.updated_at}
    end
    output = { 'status' => 'success', 'data' => frnd_list}
    respond_with output
  end

  def create
    check_friend_request = current_user.friendship_requests.where(:friend_id => params[:friend_id]).blank?
    if check_friend_request
      @friendship_request = current_user.friendship_requests.build(:friend_id => params[:friend_id])
      if @friendship_request.save
        message = "Friendship Request Sent."
        output = { 'status' => 'success', 'message' => message}
      else
        message = @friendship_request.errors
        output = { 'status' => 'failure', 'message' => message}
      end
    else
      message = "Already sent friendship request.."
      output = { 'status' => 'success', 'message' => message}
    end
    respond_to do |format|
      format.html {redirect_to users_path, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
  end

  def destroy
    @friendship = FriendshipRequest.find(params[:id])
    if @friendship.user_id == current_user.id || @friendship.friend_id == current_user.id
      if @friendship.destroy
          message = 'Removed friendship Request.'
          output = { 'status' => 'success', 'message' => message}
      else
          message = @friendship.errors
          output = { 'status' => 'failure', 'message' => message}
      end
    else
      message = 'Sorry ! you are not authorize to delete friendship request'
      output = { 'status' => 'failure', 'message' => message}
    end
        
    respond_to do |format|
      format.html {redirect_to current_user, :notice => message}
      format.json { render json: output, status: :unprocessable_entity }
      format.xml { render xml: output, status: :unprocessable_entity }
    end
  end
end
