class PasswordResetsController < ApplicationController
  def new    
  end  

  def create  
    @user = User.find_by_email(params[:email])  
    if @user  
      @user.deliver_password_reset_instructions!  
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +  
      "Please check your email."  
      redirect_to root_url  
    else  
      flash[:notice] = "No user was found with that email address"  
      render :action => :new  
    end  
  end
end
