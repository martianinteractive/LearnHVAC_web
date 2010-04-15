class Guests::AccountsController < ApplicationController
  
  def new
    @account = User.new
  end
    
  # Saving without session maintenance to skip
  # auto-login which can't happen here because
  # the User has not yet been activated
  def create
    @account = User.new(params[:user])
    @account.active = false
    @account.role_code = User::ROLES[:guest]
    
    if @account.save_without_session_maintenance
      @account.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Before login you have to activate your account. Please check your e-mail for account activation instructions!"
      redirect_to login_path
    else
      render :action => :new
    end
  end
  
end
