class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?
  
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_back_or_default(default_path_for(current_user))
      return false
    end
  end
  
  def require_admin
    unless logged_as?(:admin)
      flash[:notice] = "You must be logged in to access this page"
      redirect_back_or_default(default_path_for(current_user))
      return false
    end
  end
  
  def require_instructor
    unless logged_as?(:instructor)
      require_admin
    end
  end
  
  def require_student
    unless logged_as?(:student)
      require_admin
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    back = session[:return_to] if session[:return_to] != request.request_uri
    session[:return_to] = nil
    redirect_to(back || default)
  end
  
  def default_path_for(user)
    case user.try(:role)
    when :admin
      admin_dashboard_path
    when :instructor
      scenarios_path
    when :student
      students_groups_path
    else
      new_user_session_url
    end
  end
  
  def logged_in?
    current_user
  end
  
  def logged_as?(role)
    logged_in? and current_user.has_role?(role)
  end
  
  def initialize_variables_sort
    sort_init 'name'
    sort_update
  end
  
end
