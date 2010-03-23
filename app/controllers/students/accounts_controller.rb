class Students::AccountsController < ApplicationController
  def new
    @account = User.new
  end
  
  # Saving without session maintenance to skip
  # auto-login which can't happen here because
  # the User has not yet been activated
  def create
    @account = User.new(params[:user])
    @account.active = false
    @account.role_code = User::ROLES[:student]
    
    if @account.save_without_session_maintenance
      group = Group.find_by_code(params[:code])
      Membership.create(:group => group, :student => @account) if group
      @account.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to login_path
    else
      render :action => :new
    end
  end
  
end
