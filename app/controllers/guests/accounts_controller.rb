class Guests::AccountsController < ApplicationController
  before_filter :require_no_user
  
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
    @account.require_agreement_acceptance!
    
    if @account.save_without_session_maintenance
      @account.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Before login you have to activate your account. Please check your e-mail for account activation instructions!"
      redirect_to guests_dashboard_path(:token => @account.perishable_token)
    else
      render :action => :new
    end
  end
  
end
