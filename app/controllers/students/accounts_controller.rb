class Students::AccountsController < ApplicationController
  before_filter :require_no_user
  
  def new
    @group = Group.find_by_code(params[:code])
    @account = User.new(:group_code => @group.code)
  end
  
  def create
    @account = Student.new(params[:user])

    if @account.save_without_session_maintenance
      redirect_to(login_path, :notice => "Your account has been created. Before login you have to activate your account. Please check your e-mail for account activation instructions!")
    else
      render :action => :new
    end
  end
  
end
