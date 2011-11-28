class UsersController < ApplicationController

  layout 'bootstrap'

  before_filter :require_user

  cache_sweeper :user_sweeper, :only => :update

  caches_action :show,
                :cache_path => proc { |c| "profile/#{c.send(:current_user).login }" },
                :if => proc { |c| c.send(:flash_empty?) }

  def show
  end

  def edit
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

  def destroy
    current_user.destroy
    reset_session
    redirect_to login_path
  end

  private

  def set_layout
    self.class.layout current_user_layout
  end

end
