class UsersController < ApplicationController

  layout 'bootstrap'

  before_filter :require_user
  before_filter :set_dashboard_crumb

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
    if params["user"]["role_code"]
      current_user.role_code = params["user"]["role_code"]
    end
    if current_user.update_attributes(params[:user])
      redirect_to(profile_path, :notice => 'Your profile was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def upgrade_guest_instructor
    user = User.find current_user
    if user.has_role?:guest
      user.role_code = User::ROLES[:instructor]
    elsif user.has_role?:instructor
      user.role_code = User::ROLES[:guest]
    end
    user.save
    redirect_to profile_path
  end

  private

  def set_layout
    self.class.layout current_user_layout
  end

  def set_dashboard_crumb
    add_crumb "Dashboard", current_dashboard_path
  end

end
