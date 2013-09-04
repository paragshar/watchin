class Users::SessionsController < Devise::SessionsController
  respond_to :json, :html, :xml
 
  def destroy
    if params[:auth_token]
      @user=User.where(:authentication_token=>params[:auth_token]).first
      @user.reset_authentication_token!
    end  
    respond_to do |format|
      format.json {render :json => { :message => ["Session deleted."] },  :success => true, :status => :ok}
      format.html {super}
    end
  end

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    respond_to do |format|
      format.html do
        if current_user.admin
          redirect_to channels_path
        else
          respond_with resource
        end
         # respond_with resource
      end
      format.json do
        render :json => { :status => 'success', :auth_token => current_user.authentication_token, :user => current_user }.to_json, :status => :ok
      end
    end
  end
  protected

  def verified_request?
    request.content_type == "application/json" || super
  end
  
  

  # private
# 
  # def admin_layout
    # # Check if logged in, because current_user could be nil.
    # if logged_in? and current_user.admin
      # "admin"
    # else
      # "application"
    # end
  # end
end