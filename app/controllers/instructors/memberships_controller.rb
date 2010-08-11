class Instructors::MembershipsController < Instructors::ApplicationController
  
  def destroy
    group = current_user.managed_groups.find(params[:class_id])
    @memberships = group.memberships.where(:member_id => params[:id])
    @memberships.each { |m| m.destroy }
    redirect_to instructors_class_path(group)
  end
  
end
