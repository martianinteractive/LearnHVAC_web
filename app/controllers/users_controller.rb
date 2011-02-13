class UsersController < ApplicationController
  before_filter :require_user
  before_filter :set_layout, :set_dashboard_crumb
  
  cache_sweeper :user_sweeper, :only => :update
  
  caches_action :show,
                :cache_path => proc { |c| "profile/#{c.send(:current_user).login }" },
                :if => proc { |c| c.send(:flash_empty?) }
  
  def show
    add_crumb current_user.name, profile_path
  end
  
  def edit
    add_crumb "Editing #{current_user.name}", edit_profile_path
  end
  
  def update
    if current_user.update_attributes(params[:user])
      redirect_to(profile_path, :notice => 'Your profile was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  private
  
  def set_layout
    self.class.layout current_user_layout
  end
  
  def set_dashboard_crumb
    add_crumb "Dashboard", current_dashboard_path
  end
  
end
