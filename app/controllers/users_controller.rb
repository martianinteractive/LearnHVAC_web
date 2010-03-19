class UsersController < ApplicationController
  before_filter :require_user
  before_filter :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to(users_url)
  end
  
  private
  
  def set_user
    @user = current_user.has_role?(:admin) ? User.find(params[:id]) : current_user
  end
end
