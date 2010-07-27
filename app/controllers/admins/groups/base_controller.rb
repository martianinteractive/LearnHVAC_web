class Admins::Groups::BaseController < Admins::ApplicationController
  before_filter :find_group
  
  private
  
  def find_group
    @group = Group.find(params[:group_id])
  end
  
end
