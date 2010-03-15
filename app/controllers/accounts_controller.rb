class AccountsController < ApplicationController
  before_filter :require_no_user
  layout 'user_sessions'
  
  def new
    @account = User.new
  end
  
  # Saving without session maintenance to skip
  # auto-login which can't happen here because
  # the User has not yet been activated
  def create
    @account = User.new(params[:user])
    @account.active = false
    
    if @account.save_without_session_maintenance
      @account.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to login_path
    else
      render :action => :new
    end
  end
  
end