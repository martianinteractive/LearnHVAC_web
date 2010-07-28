class Instructors::Groups::BaseController < Instructors::ApplicationController
  before_filter :find_group
  
  private
  
  def find_group
    @group = current_user.managed_groups.find(params[:group_id])
  end
  
end