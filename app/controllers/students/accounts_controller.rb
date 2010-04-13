class Students::AccountsController < ApplicationController
  
  def new
    @account = User.new(:group_code => params[:code])
  end
  
  # Saving without session maintenance to skip
  # auto-login which can't happen here because
  # the User has not yet been activated
  def create
    @account = User.new(params[:user])
    @account.active = false
    @account.role_code = User::ROLES[:student]
    @account.require_group_code!
    
    if @account.valid? and @account.save_without_session_maintenance
      @account.register_group!
      @account.deliver_activation_instructions!
      redirect_to(login_path, :notice => "Your account has been created. Before login you have to activate your account. Please check your e-mail for account activation instructions!")
    else
      render :action => :new
    end
  end
  
end
