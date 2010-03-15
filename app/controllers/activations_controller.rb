class ActivationsController < ApplicationController
  before_filter :require_no_user
  layout 'user_sessions'
  
  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
  end
  
  def create
    @user = User.find(params[:id])

    raise Exception if @user.active?

    if @user.activate!
      flash[:notice] = "Your account has been succesfully activated your account."
      @user.deliver_activation_confirmation!
      redirect_to login_path
    else
      render :action => :new
    end
  end
  
end
