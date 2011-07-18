class ApplicationController < ActionController::Base
  include SslRequirement
  
  protect_from_forgery
  before_filter :set_user_time_zone
  helper_method :current_user, :logged_in?
  
  private
  
  def set_user_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end
  
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
      redirect_to login_path
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
    
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    back = session[:return_to] if session[:return_to] != request.fullpath
    session[:return_to] = nil
    redirect_to(back || default)
  end
  
  def default_path_for(user)
    case user.role
    when :admin
      admins_dashboard_path
    when :instructor
      instructors_dashboard_path
    when :manager
      managers_dashboard_path
    when :student
      students_classes_path
    when :guest
      guests_dashboard_path
    else
      raise ArgumentError, "role is required"
    end
  end
    
  def logged_in?
    current_user
  end
  
  def logged_as?(role)
    logged_in? and (current_user.has_role?(role) or current_user.has_role?(:admin)) #this makes admin able to access everything.
  end
  
  def notice_and_path_for(user)
    if user
      flash[:notice] = "You don't have privileges to access that page"
      redirect_back_or_default(default_path_for(user))
    else
      store_location if request.fullpath != "/"
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end
  
  User::ROLES.keys.each do |role| 
    define_method("require_#{role}") do
      unless logged_as?(role)
        notice_and_path_for(current_user)
      end
    end
  end
  
  def initialize_variables_sort
    sort_init 'name'
    sort_update
  end
  
  def current_user_layout
    current_user.role.to_s.pluralize
  end
  
  def current_dashboard_path
    begin
      send("#{current_user_layout}_dashboard_path") 
    rescue Exception => e
      "#"
    end
  end
  
  def flash_empty?
    flash.empty?
  end
  
  def paginated?
    params[:page].present? and params[:page] != "1"
  end
  
  def can_cache_action?
    flash_empty? and !paginated?
  end

  def get_list_instructors
    @instructors = User.instructor
  end
  
end
