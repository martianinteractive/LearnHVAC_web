class UsersController < ApplicationController
  before_filter :require_user
  before_filter :set_layout
  
  def show
  end
  
  def edit
  end
  
  def update
    if current_user.update_attributes(params[:user])
      redirect_to(profile_path(@user), :notice => 'Your profile was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  private
  
  def set_layout
    self.class.layout current_user_layout
  end
  
end
