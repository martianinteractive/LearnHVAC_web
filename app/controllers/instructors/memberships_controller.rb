class Instructors::MembershipsController < Instructors::ApplicationController
  
  cache_sweeper :membership_sweeper, :only => :destroy
  
  def destroy
    group = current_user.managed_groups.find(params[:class_id])
    group.memberships.where(:member_id => params[:id]).destroy_all
    redirect_to instructors_class_path(group)
  end
  
end
