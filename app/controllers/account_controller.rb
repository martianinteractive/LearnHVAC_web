class AccountController < ApplicationController
  
  require_dependency "user"
  before_filter :login_required, :except=>['index','login']

  def login
    if request.post?
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if user
        if user.role.name == "superadmin" || user.role.name == "administrator" || user.role.name =="instructor"
          session[:loggedInUserID] = user.id
          redirect_to :action=>"welcome" and return
        end
      end
      flash[:warning]  = "Login unsuccessful. Please try again."
          redirect_to :action=>"index" and return
      APPLOG.info("Login was unsuccessful by login:  "+ user.to_s)
    end
  end
  
  
  def delete
    if params['id'] and current_user
      @user = User.find(params['id'])
      @user.destroy
    end
    redirect_back_or_default :action => "welcome"
  end  
    
  def logout
    session[:loggedInUserID] = nil
    flash[:message] = 'Logged out'
    redirect_to :action => 'index'
  end
    
  def welcome
    render :action=>:welcome, :layout=>"application"
  end
  
  def unauthorized
    flash[:warning]  = "Login unsuccessful"
  end
	
  def hidden
  end
  
  def index
    respond_to do |format|
      format.html
    end
  end
  
  def help
      render :layout=>'application'
  end
  
end
