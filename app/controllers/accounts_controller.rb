class AccountsController < ApplicationController
  before_filter :require_no_user
  layout 'user_sessions'
  
  def new
    @account = User.new
  end
  
  def create
    @account = User.new(params[:user])
    
    if @user.save
      #password confirmation
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to root_path
    else
      render :action => :new
    end
  end
  
end
