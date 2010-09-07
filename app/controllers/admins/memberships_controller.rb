class Admins::MembershipsController < Admins::ApplicationController
  
  cache_sweeper :membership_sweeper, :only => :destroy
  
  def destroy
    @group = Group.find(params[:class_id])
    @group.memberships.where(:member_id => params[:id]).destroy_all
    redirect_to admins_class_path(@group)
  end
  
end
