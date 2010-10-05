class Instructors::AccountsController < ApplicationController
  before_filter :require_no_user
  
  def new
    @account = User.new
  end
  
  def create
    @account = User.new(params[:user])
    @account.active = false
    @account.role_code = User::ROLES[:instructor]
    @account.require_agreement_acceptance!
    
    if @account.save_without_session_maintenance
      @account.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Before login you have to activate your account. Please check your e-mail for account activation instructions!"
      redirect_to login_path
    else
      render :action => :new
    end
  end
  
end
