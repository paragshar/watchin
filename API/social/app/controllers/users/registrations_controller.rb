class Users::RegistrationsController < Devise::RegistrationsController

  def create

    @user = User.create(params[:user])
    # if @user.save
      # render :json => {:state => {:code => 0}, :data => @user }
    # else
      # render :json => {:state => {:code => 1, :messages => @user.errors.full_messages} }
    # end
    respond_to do |format|
      if @user.save
        output = { 'status' => 'success', 'data' => @user, :auth_token => @user.authentication_token}
        format.html {redirect_to new_user_session_path, :notice => "Registration done successfully"}
        format.json { render json: output, status: :created }
        format.xml { render xml: output, status: :created }
      else
        output = { 'status' => 'failure', 'notice' => @user.errors}
        format.html { super }
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    end

  end
  
  def update
    # logger.debug "current user id: #{id}"
    @user = User.find(current_user.id)
    respond_to do |format|
      format.html { super }
      if @user.update_attributes(params[:user])
        output = { 'status' => 'success', 'data' => @user, :auth_token => @user.authentication_token}
        
        format.json { render json: output, status: :created }
        format.xml { render xml: output, status: :created }
      else
        output = { 'status' => 'failure', 'notice' => @user.errors}
        
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    end
  end
  
 
  
end