class PasswordResetsController < ApplicationController
  layout 'signin'
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new    
  end
  
  def edit  
  end

  def create  
    @user = User.find_by_email(params[:email])  
    if @user  
      @user.deliver_password_reset_instructions!  
      flash[:notice] = "Instructions to reset your password have been emailed to you. Please check your email."
      
      redirect_to login_path  
    else  
      flash[:notice] = "No user was found with that email address"
      render :action => :new  
    end  
  end
  
  def update
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    @user.active = true unless @user.active
    if @user.save  
      flash[:notice] = "Password successfully updated"  
      redirect_to default_path_for(@user)  
    else
      flash[:notice] = "We were unable to update your password. Please try again."
      render :action => :edit  
    end
  end
  
  private  
  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])  
    unless @user  
      flash[:notice] = "We're sorry, but we could not locate your account."  
      redirect_to login_path
    end  
  end
  
end
