  # Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  helper_method :current_user

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery  :secret => '264d6dbbf0bfbea3075460fa14c40e2c'


  def login_required
  
    if current_user
			return true
		end
    
    session[:return_to]=request.request_uri
    redirect_to :controller => "account", :action => "index"
    return false 
    
  end
  
  def superadmin_required
    
    if current_user.role.name=="superadmin"
      return true
    end
    
    redirect_to_stored
    return false 
    
  end
  
  def current_user
    @current_user ||= session[:loggedInUserID] ? User.find_by_id(session[:loggedInUserID]) : nil
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to_url(return_to)
    else
      redirect_to :controller=>'account', :action=>'welcome'
    end
  end


end