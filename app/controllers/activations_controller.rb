class ActivationsController < ApplicationController
  before_filter :require_no_user
  
  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week)
    redirect_to(login_path, :notice => "Unable to find your account") and return unless @user
    redirect_to(login_path, :notice => "Your account is already active") if @user.active?
  end
  
  def create
    @user = User.find(params[:id])
    redirect_to(login_path, :notice => "Unable to find your account") and return unless @user
    redirect_to(login_path, :notice => "Your account is alredy active") and return if @user.active?

    if @user.activate!
      flash[:notice] = "Your account has been succesfully activated."
      @user.deliver_activation_confirmation!
      redirect_to login_path
    else
      render :action => :new
    end
  end
  
end
