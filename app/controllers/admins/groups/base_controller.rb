class Admins::Groups::BaseController < Admins::ApplicationController
  before_filter :find_group
  
  private
  
  def find_group
    @group = Group.find(params[:group_id])
    add_crumb @group.name, [:admins, @group]
  end
  
end
