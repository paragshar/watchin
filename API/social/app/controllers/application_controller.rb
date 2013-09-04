class ApplicationController < ActionController::Base
  protect_from_forgery
  # rescue_from Exception, :with => :error_render_method
  def error_render_method
    respond_to do |type|
      type.html { render :template => "errors/error_404", :status => 404 }
      type.all  { render :nothing => true, :status => 404 }
    end
    true
  end

  def require_login
    unless logged_in?
      message = "You must be logged in to access this section"
      output = { 'status' => 'failure', 'message' => message }
      respond_to do |format|
        format.html {redirect_to new_user_session_path, :notice => message}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    # else
      # check_admin
    end

  end

  def logged_in?
    !!current_user
  end

  def check_admin
    require_login
    if current_user.admin.blank?
      message = "You are not authorized to access this url."
      output = { 'status' => 'success', 'message' => message}
      respond_to do |format|
        format.html {redirect_to users_path, :notice => message}
        format.json { render json: output, status: :unprocessable_entity }
        format.xml { render xml: output, status: :unprocessable_entity }
      end
    end
  end

end
